class Determination < ActiveRecord::Base

  belongs_to :specimen, :touch => true

  has_one :confirmation

  has_and_belongs_to_many :determiners, :join_table => 'determination_determiners', :class_name => 'Person', :association_foreign_key => 'determiner_id'
  belongs_to :determiner_herbarium, :class_name => 'Herbarium'

  validates :specimen, :presence => true
  validates :determiners, :presence => true

  validates_length_of :division, :maximum => 255
  validates_length_of :family, :maximum => 255
  validates_length_of :order_name, :maximum => 255
  validates_length_of :genus, :maximum => 255
  validates_length_of :species, :maximum => 255
  validates_length_of :class_name, :maximum => 255
  validates_length_of :tribe, :maximum => 255
  validates_length_of :sub_family, :maximum => 255
  validates_length_of :species_authority, :maximum => 255
  validates_length_of :sub_species, :maximum => 255
  validates_length_of :sub_species_authority, :maximum => 255
  validates_length_of :variety, :maximum => 255
  validates_length_of :form, :maximum => 255
  validates_length_of :form_authority, :maximum => 255

  validates :determination_date_day, :numericality => {:only_integer => true, :allow_nil => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 31}
  validates :determination_date_month, :numericality => {:only_integer => true, :allow_nil => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 12}
  validates :determination_date_year, :numericality => {:only_integer => true, :allow_nil => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 9999}

  validates_with DateValidator, :legacy_data => :legacy, :field_name => 'Determination date', :fields =>  {:year => :determination_date_year, :month => :determination_date_month, :day => :determination_date_day}

  def get_current_level
    if !species.blank?
      return "name"
    elsif !genus.blank?
      return "genus"
    elsif !tribe.blank?
      return "tribe"
    elsif !sub_family.blank?
      return "sub_family"
    elsif !family.blank?
      return "family"
    elsif !order_name.blank?
      return "order_name"
    elsif !class_name.blank?
      return "class_name"
    elsif !division.blank?
      return "division"
    else
      return ""
    end
  end

  def set_determining_at_level(field)
    fields             = Determination.plant_name_fields
    index_of_our_field = fields.index(field)
    fields_to_blank    = fields[index_of_our_field+1..fields.length]

    fields_to_blank.each do |field_name|
      field_name = "species" if field_name == "name"
      self.send("#{field_name}=", "")
    end

    # blank lower uncertainties when switching to a higher level
    if fields_to_blank.include?("family")
      self.family_uncertainty = ""
    end
    if fields_to_blank.include?("sub_family")
      self.sub_family_uncertainty = ""
    end
    if fields_to_blank.include?("tribe")
      self.tribe_uncertainty = ""
    end
    if fields_to_blank.include?("genus")
      self.genus_uncertainty = ""
      self.naturalised       = false
    end

    if fields_to_blank.include?("name")
      self.species_authority      = ""
      self.species_uncertainty    = ""
      self.sub_species            = ""
      self.sub_species_authority  = ""
      self.subspecies_uncertainty = ""
      self.variety                = ""
      self.variety_authority      = ""
      self.variety_uncertainty    = ""
      self.form                   = ""
      self.form_authority         = ""
      self.form_uncertainty       = ""
    end

    #blank higher uncertainties when switching to a lower level
    if field == "sub_family"
      self.family_uncertainty = ""
    end
    if field == "tribe"
      self.family_uncertainty = ""
      self.sub_family_uncertainty = ""
    end
    if field == "genus"
      self.family_uncertainty = ""
      self.sub_family_uncertainty = ""
      self.tribe_uncertainty = ""
    end
    if field == "name"
      self.family_uncertainty = ""
      self.sub_family_uncertainty = ""
      self.tribe_uncertainty = ""
      self.genus_uncertainty = ""
    end
  end

  def self.get_fields_to_include_for_level(level)
    fields             = Determination.plant_name_fields
    index_of_our_field = fields.index(level)
    fields[0..index_of_our_field]
  end

  def self.plant_name_fields
    %w(division class_name order_name family sub_family tribe genus name)
  end

  def determiners_csv
    determiners.collect{|d| "#{d.display_name}"}.join(', ')
  end

  def determiners_name_herbarium_id(collector, date_matches)
    determiners.collect { |d|
      if !(collector.eql?(d.display_name) and date_matches) 
        if !d.herbarium.nil?
          "#{d.display_name} (#{d.herbarium.code})"
        else
          "#{d.display_name}"
        end
      end
    }
  end

  def collector_matches_determiner?(collector, date_matches)
    determiners.each do |d|
      if collector.eql?(d.display_name) and date_matches
        return true
      end
    end
    return false
  end

  #sort by latest first
  def <=>(other)
    other.date_as_int <=> date_as_int
  end

  def first_infraspecific_rank
    get_infraspecific_details[0][0]
  end

  def first_infraspecific_name
    get_infraspecific_details[0][1]
  end

  def first_infraspecific_authority
    get_infraspecific_details[0][2]
  end

  def second_infraspecific_rank
    get_infraspecific_details[1][0]
  end

  def second_infraspecific_name
    get_infraspecific_details[1][1]
  end

  def second_infraspecific_authority
    get_infraspecific_details[1][2]
  end

  protected
  def get_infraspecific_details
    first = [nil, nil, nil]
    second = [nil, nil, nil]

    if has_subspecies?
      first = ["subsp.", self.sub_species, self.sub_species_authority]
      if has_variety?
        second = ["var.", self.variety, self.variety_authority]
      elsif has_form?
        second = ["f.", self.form, self.form_authority]
      end
    elsif has_variety?
      first = ["var.", self.variety, self.variety_authority]
      if has_form?
        second = ["f.", self.form, self.form_authority]
      end
    elsif has_form?
      first = ["f.", self.form, self.form_authority]
    end

    return [first, second]
  end

  def date_as_int
    date_string = "%d%02d%02d" % [determination_date_year || 0, determination_date_month || 0, determination_date_day || 0]
    date_string.to_i
  end

  def has_subspecies?
    !self.sub_species.blank?
  end

  def has_variety?
    !self.variety.blank?
  end

  def has_form?
    !self.form.blank?
  end
end
