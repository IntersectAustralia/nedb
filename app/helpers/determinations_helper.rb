include ApplicationHelper

module DeterminationsHelper


  def hash_of_field_values(species, fields_to_show)
    values = {}
    fields_to_show.each { |field| values[field] = species.send("#{field}") }
    values
  end

  def map_field_to_display_name(field_name)
    map = {"division" => "Division", "class_name" => "Class", "order_name" => "Order", "family" => "Family", "sub_family" => "Subfamily", "tribe" => "Tribe", "genus" => "Genus", "name" => "Species"}
    map[field_name]
  end
end
