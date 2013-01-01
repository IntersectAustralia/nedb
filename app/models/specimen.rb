# encoding: UTF-8

require 'zip/zip'
class Specimen < ActiveRecord::Base

  belongs_to :collector, :class_name => 'Person'
  has_and_belongs_to_many :secondary_collectors, :join_table => 'specimen_secondary_collectors', :class_name => 'Person', :association_foreign_key => 'collector_id'
  has_and_belongs_to_many :replicates, :join_table => 'specimen_replicates', :class_name => 'Herbarium', :association_foreign_key => 'herbarium_id'
  has_many :determinations
  has_many :confirmations   
  has_many :items
  has_many :specimen_images

  # protect status and needs review from being updated by mass assignment. Better practice would be to use attr_accessible but this will do for now
  attr_protected :status, :needs_review

  validates :collector, :presence => true
  validates :state,     :presence => true, :if => :in_australia?
  validates :collection_date_day, :numericality => {:only_integer => true, :allow_nil => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 31}
  validates :collection_date_month, :numericality => {:only_integer => true, :allow_nil => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 12}
  validates :collection_date_year, :numericality => {:only_integer => true, :allow_nil => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 9999}
  validates :altitude, :numericality => {:only_integer => true, :allow_nil => true, :less_than => 2147483647}
  
  validates :latitude_degrees, :numericality => {:only_integer => true, :allow_nil => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 90}
  validates :latitude_minutes, :numericality => {:only_integer => true, :allow_nil => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 59}
  validates :latitude_seconds, :numericality => {:allow_nil => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 60}
  validates :longitude_degrees, :numericality => {:only_integer => true, :allow_nil => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 180}
  validates :longitude_minutes, :numericality => {:only_integer => true, :allow_nil => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 59}
  validates :longitude_seconds, :numericality => {:allow_nil => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 60}

  validates_length_of :collector_number, :maximum => 255
  validates_length_of :state, :maximum => 255
  validates_length_of :botanical_division, :maximum => 255
  validates_length_of :aspect, :maximum => 255
  validates_length_of :frequency, :maximum => 255
  validates_length_of :replicate_from, :maximum => 255
  validates_length_of :replicate_from_no, :maximum => 255
  validates_length_of :datum, :maximum => 255

  validates_with DateValidator, :legacy_data => :legacy, :field_name => 'Collection date', :fields => {:year => :collection_date_year, :month => :collection_date_month, :day => :collection_date_day}
  scope :needing_review, where(:needs_review => 'true')

  def in_australia?
    if country
      country.upcase == "AUSTRALIA"
    else
      false
    end
  end

  def replicates_comma_separated
    codes = replicates.order(:code).collect { |r| r.code }
    if codes.include?(Herbarium::STUDENT_HERBARIUM_CODE)
      codes.delete(Herbarium::STUDENT_HERBARIUM_CODE)
      codes << Herbarium::STUDENT_HERBARIUM_CODE
    end
    codes.join(", ")
  end

  def determinations_naturalised_is

  end

  def items_comma_separated_excluding_specimen_sheet
    item_types = unique_item_types
    item_types.delete_if { |i| i == ItemType::TYPE_SPECIMEN_SHEET}
    item_types.join(", ")
  end

  def items_comma_separated
    unique_item_types.join(", ")
  end

  def secondary_collectors_comma_separated
    names = secondary_collectors.collect { |c| c.display_name }
    names.join(", ")
  end

  def secondary_collectors_semicolon_separated
    names = secondary_collectors.collect { |c| c.display_name }
    names.join('; ')
  end
  
  def altitude_with_unit
    "#{self.altitude} m" unless self.altitude.blank?
  end
  
  def current_determination
    determinations.sort!.first
  end
  
  def latitude_printable
    latlong_printable(self.latitude_degrees, self.latitude_minutes, self.latitude_seconds, self.latitude_hemisphere)
  end

  def longitude_printable
    latlong_printable(self.longitude_degrees, self.longitude_minutes, self.longitude_seconds, self.longitude_hemisphere)
  end
 
  def latitude_decimal_printable
    latlong_to_decimal_conversion(self.latitude_degrees, self.latitude_minutes, self.latitude_seconds, self.latitude_hemisphere)
  end
 
  def longitude_decimal_printable
    latlong_to_decimal_conversion(self.longitude_degrees, self.longitude_minutes, self.longitude_seconds, self.longitude_hemisphere)
  end
 
  def request_deaccession
    self.status = "DeAccReq"
    save!
    
    Notifier.notify_superusers_of_deaccession_request(self).deliver
  end
  
  def deaccession_requested?
    self.status == "DeAccReq"
  end
  
  def approve_deaccession
    self.status = "DeAcc"
    save!
  end
  
  def deaccession_approved?
    self.status == "DeAcc"
  end
  
  def unflag_deaccession
    self.status = ""
    save!
  end
  
  def deaccession_unflagged?
    self.status == nil || self.status == ""
  end
  
  def mark_as_reviewed
    self.needs_review = false
    save!
  end
  
  def self.free_text_search(free_text)
    text = free_text.gsub("'", "''")
    search = '%' + text.downcase + '%'
    search_fields = %w{division class_name order_name family sub_family genus species sub_species variety form}
    condition = "(" + search_fields.collect { |field| "lower(D.#{field}) like '#{search}' "}.join(" OR ")
    condition += ") AND S.needs_review = false "
    Specimen.select("S.*").where(condition).joins(" as S inner join latest_determination as D on S.id = D.specimen_id")
  end
  
  def self.remove_fullstops(form_values)
    keywords = ["locality_description", "frequency", "plant_description", "topography", "aspect", "substrate", "vegetation", "botanical_division"]
    form_values.each do |key, value|
      value.rstrip!             # remove whitespace
      value.slice! /[\r\n]+/    # remove any newlines or returns
      if keywords.include? key
        value.slice! /\.+$/     # remove full stops
        form_values[key] = value
      end
    end if form_values
  end
  
  # CSV headers
  def self.get_header
    ["Accession Number", "Collector", "Collector Number", "Collection Date", "Other Collectors", "Country", "State", "Botanical Division", "Locality Description",
     "Latitude", "Longitude", "Altitude", "Point Data", "Datum", "Topography", "Aspect", "Substrate", "Vegetation", "Frequency",
     "Plant Description", "Reps", "Items", "De-accessioned", "Replicate From", "Replicate From No.",
     "Determiners", "Determination Date", "Determiner Herbarium",
     "Division", "Class", "Order", "Family", "Family Uncertainty", "Subfamily", "Subfamily Uncertainty", "Tribe", "Tribe Uncertainty", "Genus", "Genus Uncertainty", "Naturalised",
     "Species", "Species Authority", "Species Uncertainty",
     "Subspecies", "Subspecies Authority", "Subspecies Uncertainty", "Variety", "Variety Authority", "Variety Uncertainty", "Form", "Form Authority", "Form Uncertainty",
     "Confirmer", "Confirmer Herbarium", "Confirmation Date"]
  end
 
  # CSV data fields
  def add_csv_row
    date = format_partial_date_for_csv(self.collection_date_year, self.collection_date_month, self.collection_date_day)
    current_det = self.current_determination

    fields = [
      self.id, 
      self.collector.display_name, 
      self.collector_number,
      date,
      self.secondary_collectors_comma_separated, 
      self.country, 
      self.state, 
      self.botanical_division, 
      self.locality_description,
      self.latitude_decimal_printable, 
      self.longitude_decimal_printable, 
      self.altitude_with_unit, 
      self.point_data, 
      self.datum, 
      self.topography, 
      self.aspect, 
      self.substrate, 
      self.vegetation, 
      self.frequency, 
      self.plant_description, 
      self.replicates_comma_separated, 
      self.items_comma_separated, 
      self.status, 
      self.replicate_from, 
      self.replicate_from_no ]

    if current_det
      determination_date = format_partial_date_for_csv(current_det.determination_date_year, current_det.determination_date_month, current_det.determination_date_day)
      determiner_herbarium_code = current_det.determiner_herbarium ? current_det.determiner_herbarium.code : nil

      fields = fields + [ 
        current_det.determiners_csv, 
        determination_date, 
        determiner_herbarium_code,
        current_det.division, 
        current_det.class_name, 
        current_det.order_name, 
        current_det.family, 
        current_det.family_uncertainty,
        current_det.sub_family,
        current_det.sub_family_uncertainty,
        current_det.tribe,
        current_det.tribe_uncertainty,
        current_det.genus,
        current_det.genus_uncertainty,
        current_det.naturalised.to_s,
        current_det.species,
        current_det.species_authority, 
        current_det.species_uncertainty,
        current_det.sub_species, 
        current_det.sub_species_authority, 
        current_det.subspecies_uncertainty ,
        current_det.variety, 
        current_det.variety_authority, 
        current_det.variety_uncertainty,
        current_det.form, 
        current_det.form_authority, 
        current_det.form_uncertainty ]

      current_conf = current_det.confirmation
      if current_conf
        conf_date = format_partial_date(current_conf.confirmation_date_year, current_conf.confirmation_date_month, current_conf.confirmation_date_day)
        confirmer_herbarium_code = current_conf.confirmer_herbarium ? current_conf.confirmer_herbarium.code : nil

        fields = fields + [current_conf.confirmer.display_name, confirmer_herbarium_code, conf_date]
      end
    end

    fields
  end

  def with_images_in_temp_zip_file()
    unless specimen_images.empty? then
      t = Tempfile.new("#{id}.zip")
      temp_file_name = t.path
      t.delete
    
      Zip::ZipFile.open(temp_file_name, Zip::ZipFile::CREATE) do |zip_file|
        images_unique_names = uniquify(specimen_images)
        images_unique_names.each_entry do |img, unique_name|
          zip_file.add unique_name, img.image.path
        end
      end
 
      yield temp_file_name
      File.delete(temp_file_name)
    end
  end

  def has_labellable_items?
    !items.requiring_labels.empty? || !replicates.empty?
  end

  private
  # invent a unique name for each image
  # names with spaces are converted to underscores
  # in the event of duplicates, attempt to rename them blah 1.pic.jpg, blah 2.pic.jpg etc.
  def uniquify(images)
    unique_name_to_image = {}
    indices = {}
    images.each do |img|
      base_name = img.image_file_name.gsub /\ /, '_'
      if indices.has_key? base_name then
        indices[base_name] +=1
        splat = base_name.split '.', 2
        if splat.length == 2 then
          unique_name = "#{splat[0]} #{indices[base_name]}.#{splat[1]}"
        else
          unique_name = "#{base_name} #{indices[base_name]}"
        end
      else
        indices[base_name] = 0
        unique_name = base_name
      end
      unique_name_to_image[img] = unique_name
    end
    return unique_name_to_image
  end

  def latlong_printable(deg, min, sec, hem)
    str = ""
    str << "#{deg}° " if deg
    str << "#{min}' " if min
    if sec
      sec_str = sec.frac == 0 ? sec.to_i.to_s : sec.to_s('F')
      str << "#{sec_str}\" "
    end
    str << "#{hem}" if (hem && !str.empty?)
    str
  end

  def latlong_to_decimal_conversion(deg, min, sec, hem)
    # conversion formula being used is (Degrees + Minutes/60 + Seconds/3600)
    decimal = deg.to_f + min.to_f/60 + sec.to_f/3600
    str = ""
    if decimal != 0.0
      str << decimal.to_s
      str << " #{hem}" if (hem && !str.empty?)
    end
    str
  end

  def unique_item_types
    item_types = items.collect { |i| i.item_type.name }
    item_types.uniq!
    item_types.sort
  end
end
