require 'barby/outputter/prawn_outputter'

include ApplicationHelper

# Wrapper around the SpecimenNameFormatter which escapes all strings before using them.
# This is so that this can be used by HTML pages while SpecimenNameFormatter can be used for PDF generation where we don't want to do escaping
module SpecimensHelper

  def form_and_authority(det)
    SpecimenNameFormatter.form_and_authority(h(det.form), h(det.form_authority), det.form_uncertainty, det.species).html_safe
  end

  def variety_and_authority(det)
    SpecimenNameFormatter.variety_and_authority(h(det.variety), h(det.variety_authority), det.variety_uncertainty, det.species).html_safe
  end

  def subspecies_and_authority(det)
    SpecimenNameFormatter.subspecies_and_authority(h(det.sub_species), h(det.sub_species_authority), det.subspecies_uncertainty, h(det.species)).html_safe
  end

  def family_subfamily(det)
    SpecimenNameFormatter.family_subfamily(h(det.family), h(det.sub_family), det.family_uncertainty, det.sub_family_uncertainty).html_safe
  end

  def family(det)
    SpecimenNameFormatter.family(h(det.family), det.family_uncertainty).html_safe
  end

  def sub_family(det)
    SpecimenNameFormatter.sub_family(h(det.sub_family), det.sub_family_uncertainty).html_safe
  end

  def tribe(det)
    SpecimenNameFormatter.tribe(h(det.tribe), det.tribe_uncertainty).html_safe
  end

  def genus(det)
    SpecimenNameFormatter.genus(h(det.genus), det.genus_uncertainty, det.naturalised).html_safe
  end

  def species(det)
    SpecimenNameFormatter.species(h(det.species), det.species_uncertainty).html_safe
  end

  def determination_name (det)
    fields = [family(det), sub_family(det), determination_short_name(det)]
    fields.join(" ").html_safe
  end

  def species_short_name (det)
    SpecimenNameFormatter.short_name(h(det.species), h(det.species_authority), det.species_uncertainty)
  end
  
  def determination_short_name (det)
    parts = []
    parts << tribe(det)
    parts << genus(det)
    parts << species_short_name(det)
    parts.join(" ").html_safe
  end

end
