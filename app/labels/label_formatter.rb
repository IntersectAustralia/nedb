class LabelFormatter

  def initialize(specimen)
    @specimen = specimen
  end

  def specimen
    @specimen
  end

  def accession_number
    "NE #{@specimen.id}"
  end

  def family_sub_family
    current_det = @specimen.current_determination
    SpecimenNameFormatter.family_subfamily(current_det.family, current_det.sub_family, current_det.family_uncertainty, current_det.sub_family_uncertainty)
  end

  def tribe
    current_det = @specimen.current_determination
    SpecimenNameFormatter.tribe(current_det.tribe, current_det.tribe_uncertainty)
  end

  def genus_species_and_authority
    det = @specimen.current_determination
    parts = []
    parts << tribe
    parts << SpecimenNameFormatter.genus(det.genus, det.genus_uncertainty, det.naturalised).html_safe
    parts << SpecimenNameFormatter.short_name(det.species, det.species_authority, det.species_uncertainty)
    parts.join(" ").html_safe
  end

  def subspecies_and_authority
    det = @specimen.current_determination
    SpecimenNameFormatter.subspecies_and_authority(det.sub_species, det.sub_species_authority, det.subspecies_uncertainty, det.species)
  end

  def variety_and_authority
    det = @specimen.current_determination
    SpecimenNameFormatter.variety_and_authority(det.variety, det.variety_authority, det.variety_uncertainty)
  end

  def form_and_authority
    det = @specimen.current_determination
    SpecimenNameFormatter.form_and_authority(det.form, det.form_authority, det.form_uncertainty)
  end

  def frequency_plant_description
    line = ""
    line << "#{@specimen.frequency}. "        unless @specimen.frequency.blank?
    line << "#{@specimen.plant_description}." unless @specimen.plant_description.blank?
    line
  end

  def locality_botanical_division_locality_description
    line = []
    line << "<b>#{@specimen.country.upcase}</b>"  unless @specimen.country.blank?
    line << "#{@specimen.state}"                  unless @specimen.state.blank?
    line << "#{@specimen.botanical_division}"     unless @specimen.botanical_division.blank?
    line << "#{@specimen.locality_description}."  unless @specimen.locality_description.blank?
    line.join(": ")
  end

  def latitude_longitude
    "#{@specimen.latitude_printable}     #{@specimen.longitude_printable}"
  end

  def datum_altitude
   "#{@specimen.altitude_with_unit}    #{@specimen.datum}"
  end

  def topography_aspect_substrate_vegetation
    line = ""
    line << "#{@specimen.topography}. "    unless @specimen.topography.blank?
    line << "#{@specimen.aspect} aspect. " unless @specimen.aspect.blank?
    line << "#{@specimen.substrate}. "     unless @specimen.substrate.blank?
    line << "#{@specimen.vegetation}."     unless @specimen.vegetation.blank?
    line
  end

  def collector
    "Coll.: <b>#{@specimen.collector.display_name} #{@specimen.collector_number}</b>"
  end

  def collection_date
    collection_date = format_partial_date(@specimen.collection_date_year, @specimen.collection_date_month, @specimen.collection_date_day)
    if collection_date.empty?
      ""
    else
      "#{collection_date}"
    end
  end

  def items
    if @specimen.items_comma_separated_excluding_specimen_sheet.blank?
      ""
    else
      "#{@specimen.items_comma_separated_excluding_specimen_sheet}."
    end
  end

  def determiners
    determiners = @specimen.current_determination.determiners_name_herbarium_id(@specimen.collector.display_name, collection_date.eql?(det_date)).compact
    "Det.: #{determiners.join(", ")}"
  end

  def determination_date
    if !@specimen.current_determination.collector_matches_determiner?(@specimen.collector.display_name, collection_date.eql?(det_date))
      "#{det_date}"
    else
      ""
    end
  end

  def det_date
    format_partial_date(@specimen.current_determination.determination_date_year, @specimen.current_determination.determination_date_month, @specimen.current_determination.determination_date_day)
  end

  def replicates
    reps = @specimen.replicates_comma_separated
    if reps.blank?
      "Rep.:"
    else
      # only put full stop at the end if there isn't already one there
      suffix = reps[-1,1] == "." ? "" : "."
      if reps.index(",") != nil
        "Reps: #{reps}#{suffix}"
      else
        "Rep.: #{reps}#{suffix}"
      end
    end
  end

  def total_number_of_numbered_sheets
    @specimen.items.requiring_labels.find_all { |item| item.item_type.name == ItemType::TYPE_SPECIMEN_SHEET }.count
  end

end
