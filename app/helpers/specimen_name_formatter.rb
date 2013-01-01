class SpecimenNameFormatter

  def self.subspecies_and_authority(name, authority, uncertainty, species)
    prefix = "subsp."

    if species == name
      # don't show authority if species is same as subspecies
      authority = ""
    end
    format_and_add_uncertainty(authority, name, prefix, uncertainty)
  end

  def self.variety_and_authority(name, authority, uncertainty)
    prefix = "var."
    format_and_add_uncertainty(authority, name, prefix, uncertainty)
  end

  def self.form_and_authority(name, authority, uncertainty)
    prefix = "f."
    format_and_add_uncertainty(authority, name, prefix, uncertainty)
  end

  def self.family_subfamily(family, subfamily, family_uncertainty, subfamily_uncertainty)
    parts = []
    if family and !family.empty?
      parts << append_uncertainty(family, family_uncertainty)
    end

    if subfamily and !subfamily.empty?
      parts << "subfam."
      parts << append_uncertainty(subfamily, subfamily_uncertainty)
    end

    parts.join(" ")
  end

  def self.family(family, family_uncertainty)
    if family and !family.empty?
      append_uncertainty(family, family_uncertainty)
    else
      ""
    end
  end

  def self.sub_family(sub_family, sub_family_uncertainty)
    if sub_family and !sub_family.empty?
      append_uncertainty(sub_family, sub_family_uncertainty)
    else
      ""
    end
  end

  def self.tribe(tribe, tribe_uncertainty)
    if tribe and !tribe.empty?
      append_uncertainty(tribe, tribe_uncertainty)
    else
      ""
    end
  end

  def self.genus(genus, genus_uncertainty, naturalised)
    if genus and !genus.empty?
      genus_str = bold_and_italicise(genus)
      genus_str = ("*" + genus_str) if naturalised
      append_uncertainty(genus_str, genus_uncertainty)
    else
      ""
    end
  end

  def self.short_name(species, species_authority, species_uncertainty)
    if species and !species.empty?
      parts     = []
      name_part1= ""
      name_part2 = ""
      if species_uncertainty.eql?("?")
        name_part1+="?"
      elsif species_uncertainty.eql?("aff.")
        name_part1+=" "+ get_uncertainty(species_uncertainty)+" "
      else
        name_part2 =  get_uncertainty(species_uncertainty)
      end
      name_part1 += species_only(species)
      parts << name_part1
      parts << species_authority
      parts << name_part2
    end

  end

  def self.species(species, species_uncertainty)
    if species and !species.empty?
      italicise_species = species.index('sp.').nil?
      species_name      = italicise_species ? bold_and_italicise(species) : species
      append_uncertainty(species_name, species_uncertainty)
    else
      ""
    end
  end

  def self.species_only(species)
    if species and !species.empty?
      italicise_species = species.index('sp.').nil?
      species_name      = italicise_species ? bold_and_italicise(species) : species
    else
      ""
    end
  end



  private

  def self.append_uncertainty(text, uncertainty)
    updated_text = case uncertainty
                     when "?" then
                       "?#{text}"
                     when "sens. strict." then
                       "#{text} <i>s. str.</i>"
                     when "sens. lat." then
                       "#{text} <i>s. lat.</i>"
                     when "vel. aff." then
                       "#{text} <i>vel. aff.</i>"
                     when "aff." then
                       "<i>aff.</i> #{text}"
                     else
                       text
                   end
    updated_text
  end

  def self.get_uncertainty( uncertainty)
    updated_text = case uncertainty
                     when "sens. strict." then
                       "<i>s. str.</i>"
                     when "sens. lat." then
                       "<i>s. lat.</i>"
                     when "vel. aff." then
                       "<i>vel. aff.</i>"
                     when "aff." then
                       "<i>aff.</i>"
                     else
                       ""
                   end
    updated_text
  end

  def self.bold_and_italicise(text)
    "<b><i>#{text}</i></b>"
  end

  def self.format_and_add_uncertainty(authority, name, prefix, uncertainty)
    if !name or name.empty?
      return ""
    end

    parts     = [prefix]

    name_part = bold_and_italicise(name)
    name_part = append_uncertainty(name_part, uncertainty)
    parts << name_part

    parts << "#{authority}" if authority and !authority.empty?
    parts.join(" ")
  end

end