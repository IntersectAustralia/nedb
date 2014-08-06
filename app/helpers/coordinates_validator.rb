class CoordinatesValidator < ActiveModel::Validator

  def initialize(search_params)
    @search_params = search_params.nil? ? nil : search_params
  end

  def validate_coordinates
    lat_deg_from, lat_min_from, lat_sec_from, lat_deg_to, lat_min_to, lat_sec_to, long_deg_from, long_min_from, long_sec_from, long_deg_to, long_min_to, long_sec_to = sanitize_lat_and_long
    validate(lat_deg_from, lat_min_from, lat_sec_from, "Latitude from", :latitude)
    validate(lat_deg_to, lat_min_to, lat_sec_to, "Latitude to", :latitude)
    validate(long_deg_from, long_min_from, long_sec_from, "Longitude from", :longitude)
    validate(long_deg_to, long_min_to, long_sec_to, "Longitude to", :longitude)
    validate_from_less_than_or_equal_to_to(lat_deg_from, lat_min_from, lat_sec_from, lat_deg_to, lat_min_to, lat_sec_to, :latitude)
    validate_from_less_than_or_equal_to_to(long_deg_from, long_min_from, long_sec_from, long_deg_to, long_min_to, long_sec_to, :longitude)
    @record
  end

  def sanitize_lat_and_long
    [
      :latitude_degrees_greater_than_or_equal_to,
      :latitude_minutes_greater_than_or_equal_to,
      :latitude_seconds_greater_than_or_equal_to,
      :latitude_degrees_less_than_or_equal_to,
      :latitude_minutes_less_than_or_equal_to,
      :latitude_seconds_less_than_or_equal_to,
      :longitude_degrees_greater_than_or_equal_to,
      :longitude_minutes_greater_than_or_equal_to,
      :longitude_seconds_greater_than_or_equal_to,
      :longitude_degrees_less_than_or_equal_to,
      :longitude_minutes_less_than_or_equal_to,
      :longitude_seconds_less_than_or_equal_to
    ].collect {|x| @search_params[x].blank? ? nil : @search_params[x].to_i}
  end

  def validate(deg, min, sec, field_name, type)
    if deg
      if type.eql? :latitude
        if deg > 90 or deg < 0
          @record = "You have entered an invalid degree for #{field_name}."
        end
      elsif type.eql? :longitude
        if deg > 180 or deg < 0
          @record = "You have entered an invalid degree for #{field_name}."
        end
      end
    else
      # min and/or sec without deg is invalid
      if min || sec
        @record = "Enter degrees for #{field_name}."
      end
    end

    # sec without min is invalid
    if sec && min.nil?
      @record = "Enter minutes for #{field_name}."
    end
  end

  def validate_from_less_than_or_equal_to_to(deg_from, min_from, sec_from, deg_to, min_to, sec_to, type)
    # Only validate if other validations pass
    unless @record
      from = deg_from * 3600 if deg_from
      from = from + min_from * 60 if min_from
      from = from + sec_from if sec_from
      to = deg_to * 3600 if deg_to
      to = to + min_to * 60 if min_to
      to = to + sec_to if sec_to

      if from && to && from > to
        field_title = type.to_s.capitalize
        @record = "#{field_title} to value must be greater than #{field_title} from value"
      end
    end
  end

end