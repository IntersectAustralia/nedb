require 'csv'

def do_migration
  Confirmation.delete_all
  Determination.delete_all
  Item.delete_all
  Specimen.delete_all

  Person.delete_all

  load_specimens_from_file
end

def load_specimens_from_file
  CSV.foreach(File.dirname(__FILE__) + '/ne_data.csv') do |vals|
    div_class = vals[2].strip
    family = vals[3].strip
    genus = vals[4].strip
    species = vals[5].strip
    species_auth = vals[6].strip
    infra = vals[7].strip
    determiner = vals[8].strip
    det_date = vals[9].strip

    country = vals[10].strip
    state = vals[11].strip
    bd = vals[12].strip
    locality = vals[13].strip
    lat = vals[14].strip
    long = vals[15].strip
    altitude = vals[16].strip
    collector = vals[17].strip
    coll_num = vals[18].strip
    secondary_colls = vals[19]
    coll_date = vals[20].strip
    vegetation = vals[22].strip
    plant_desc = vals[23].strip
    dates = parse_date(coll_date)


    if lat and !lat.empty?
      lat_hem = lat[-1,1]
      lat_rest = lat[0,lat.length-2].split(":")
      lat_d = lat_rest[0]
      lat_m = lat_rest[1]
      lat_s = lat_rest[2]
    else
      lat_hem = ""
      lat_d = ""
      lat_m = ""
      lat_s = ""
    end

    if long and !long.empty?
      long_hem = long[-1,1]
      long_rest = long[0,long.length-2].split(":")
      long_d = long_rest[0]
      long_m = long_rest[1]
      long_s = long_rest[2]
    else
      long_hem = ""
      long_d = ""
      long_m = ""
      long_s = ""
    end

    person = get_person(collector)

    specimen = Specimen.new(:collector => person,
                                :collector_number => coll_num,
                                :collection_date_year => dates[2],
                                :collection_date_month => dates[1],
                                :collection_date_day => dates[0],
                                :country => country,
                                :state => state,
                                :botanical_division => bd,
                                :locality_description => locality,
                                :latitude_degrees => lat_d,
                                :latitude_minutes => lat_m,
                                :latitude_seconds => lat_s,
                                :latitude_hemisphere => lat_hem,
                                :longitude_degrees => long_d,
                                :longitude_minutes => long_m,
                                :longitude_seconds => long_s,
                                :longitude_hemisphere => long_hem,
                                :altitude => altitude,
                                :point_data => "",
                                :datum => "",
                                :topography => "",
                                :aspect => "",
                                :substrate => "",
                                :vegetation => vegetation,
                                :frequency => "",
                                :plant_description => plant_desc,
                                :needs_review => false)
    if !specimen.valid?
      puts "Couldn't create specimen #{vals[0]} #{specimen.errors}"
    else
      specimen.save!

      if determiner and !determiner.blank?
        d = get_person(determiner)
      else
        d = person
      end

      det_date_parts = parse_date(det_date)
      det = specimen.determinations.build(:division                 => div_class,
                                          :class_name               => "",
                                          :family                   => family,
                                          :order_name               => "",
                                          :tribe                    => "",
                                          :genus                    => genus,
                                          :species                  => species,
                                          :sub_family               => "",
                                          :determiner_herbarium_id  => "",
                                          :species_authority        => species_auth,
                                          :determination_date_year  => det_date_parts[2],
                                          :determination_date_month => det_date_parts[1],
                                          :determination_date_day   => det_date_parts[0],
                                          :sub_species              => "",
                                          :sub_species_authority    => "",
                                          :variety                  => "",
                                          :variety_authority        => "",
                                          :form                     => "",
                                          :form_authority           => "",
                                          :species_uncertainty      => "",
                                          :subspecies_uncertainty   => "",
                                          :variety_uncertainty      => "",
                                          :form_uncertainty         => "",
                                          :determiners              => [d])

      if !det.valid?
        puts "det not valid #{det.errors}"
      else
        det.save!
      end

    end

  end

end

def parse_date(text)
  [1,1,2000]
end

def get_person(disp_name)
  name = disp_name
  if name.blank?
    name = "was blank"
  end
  p = Person.where(["LOWER(display_name) = ?", name.downcase]).first
  if (!p)
    p = Person.create!(:display_name => name, :first_name => "Test")
  end
  p

end