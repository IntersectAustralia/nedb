require File.join(Rails.root, 'db/seed_helper.rb')

When /^I have the usual seeded data$/ do
  create_countries
  create_states
  create_botanical_divisions
  create_herbaria
  create_item_types
  create_uncertainty_types
  create_people

end

When /^I have the advanced search test specimens$/ do

  species_params = {}
  species_params[:authority] = "Clint Eastwood"
  species_params[:class_name] = "CE Class name"
  species_params[:division] = "CE Division"
  species_params[:family]= "CE Family"
  species_params[:genus] ="Ce genus"
  species_params[:name] = "ce Name2"
  species_params[:order_name] = "CE Order Name"
  species_params[:sub_family] = "CESub Family"
  species_params[:tribe] = "CE Tribe"

  species = Species.create!(species_params)

  Subspecies.create!(:species => species, :subspecies => "Subspecies Primera", :authority => "Don Siegel")
  Subspecies.create!(:species => species, :subspecies => "Subspecies Segunda", :authority => "Ted Post")
  Subspecies.create!(:species => species, :subspecies => "Subspecies Tercera", :authority => "James Fargo")

  Variety.create!(:species => species, :variety => "Variety Cuarenta", :authority => "Clint Eastwood")
  Variety.create!(:species => species, :variety => "Variety Cinquenta", :authority => "Clint Eastwood")
  Variety.create!(:species => species, :variety => "Variety Sesenta", :authority => "Buddy Van Horn")

  Form.create!(:species => species, :form => "Form Septima", :authority => "Matt Braxton")
  Form.create!(:species => species, :form => "Form Octava", :authority => "Harry Callahan")
  Form.create!(:species => species, :form => "Form Novena", :authority => "Tyne Daly")

  (1..10).each do |i|
    Subspecies.create!(:species => species, :subspecies => "Subspecies#{i}", :authority => "Don Siegel")
    Variety.create!(:species => species, :variety => "Var#{i}", :authority => "Clint Eastwood")
    Form.create!(:species => species, :form =>"Form#{i}", :authority => "Tyne Daly")
  end

  csv_data = CSV.read (File.join(Rails.root,'features/support/advanced_search_test.csv'))
  headers = csv_data.shift.map {|i| i.to_s }
  string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
  rows = string_data.map {|row| Hash[*headers.zip(row).flatten] }
  @specimens = []

  rows.each_with_index do |row, index|
    specimen_attrs = row.select {|k,v| k.to_s[/^[cd]_/].nil?}
    determination_attrs = Hash[row.select {|k,v| k.to_s[/^d_/].present?}.map {|k, v| [k[2..-1], v] }]
    confirmation_attrs = Hash[row.select {|k,v| k.to_s[/^c_/].present?}.map {|k, v| [k[2..-1], v] }]
    specimen_attrs['collector'] = Person.find_by_initials(specimen_attrs['collector'])
    specimen_attrs['secondary_collectors'] = Person.find_all_by_initials(specimen_attrs['secondary_collectors'].split(","))
    specimen_attrs['replicates'] = Herbarium.find_all_by_code(specimen_attrs['replicates'].split(","))

    items = specimen_attrs.delete('items')
    specimen = Specimen.create!(specimen_attrs)
    specimen.update_attribute(:needs_review,specimen_attrs['needs_review'])
    if items.present?
      types = ItemType.find_all_by_name(items.split(","))
      types.each do |type|
        specimen.items.create(item_type: type)
      end
    end

    species_keys =  [:authority, :class_name, :species, :division, :family, :genus, :name, :order_name, :sub_family, :tribe]

    species_params = determination_attrs.select { |key, value| species_keys.include?(key.to_sym) }
    species_params['name'] = species_params.delete('species')
    species_params['authority'] = "NEDB Test"
    if species_params['name'].present?
      Species.create!(species_params)
    else

    end

    determination_attrs['determiners'] = Person.find_all_by_initials(determination_attrs['determiners'].split(","))
    determination_attrs['determiner_herbarium_id'] = Herbarium.find_all_by_code(determination_attrs['determiner_herbarium_id'].split(","))
    determination = specimen.determinations.create!(determination_attrs)

    if confirmation_attrs['confirmer'].present?
      confirmation_attrs['confirmer'] = Person.find_by_initials(confirmation_attrs['confirmer'].split(","))
      confirmation_attrs['confirmer_herbarium_id'] = Herbarium.find_all_by_code(confirmation_attrs['confirmer_herbarium_id'].split(","))
      confirmation_attrs['determination'] = determination
      specimen.confirmations.create!(confirmation_attrs)
    end

    @specimens[index+1] = specimen.id
  end

end

  # Add more columns to check
When /^I should see specimens "([^"]*)"$/ do |specimens|
  indices = specimens.split(",").map(&:to_i)
  ids = @specimens.values_at(*indices)

  array = [ "Locality" ] + Specimen.order(:id).where(id: ids).collect(&:locality_description)
  step "the advanced search result table should contain", table(array.map {|value| [value]})
 end
