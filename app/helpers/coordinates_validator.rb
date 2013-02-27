class CoordinatesValidator < ActiveModel::Validator

  def initialize(search_params)
    @search_params = search_params.nil? ? nil : search_params
  end

  def validate_coordinates
    lat_deg_from = @search_params[:latitude_degrees_greater_than_or_equal_to].to_i
    lat_min_from = @search_params[:latitude_minutes_greater_than_or_equal_to].to_i
    lat_sec_from = @search_params[:latitude_seconds_greater_than_or_equal_to].to_i
    lat_deg_to = @search_params[:latitude_degrees_less_than_or_equal_to].to_i
    lat_min_to = @search_params[:latitude_minutes_less_than_or_equal_to].to_i
    lat_sec_to = @search_params[:latitude_seconds_less_than_or_equal_to].to_i

    long_deg_from = @search_params[:longitude_degrees_greater_than_or_equal_to].to_i
    long_min_from = @search_params[:longitude_minutes_greater_than_or_equal_to].to_i
    long_sec_from = @search_params[:longitude_seconds_greater_than_or_equal_to].to_i
    long_deg_to = @search_params[:longitude_degrees_less_than_or_equal_to].to_i
    long_min_to = @search_params[:longitude_minutes_less_than_or_equal_to].to_i
    long_sec_to = @search_params[:longitude_seconds_less_than_or_equal_to].to_i

    validate(lat_deg_from, lat_min_from, lat_sec_from, "Latitude from", :latitude)
    validate(lat_deg_to, lat_min_to, lat_sec_to, "Latitude to", :latitude)
    validate(long_deg_from, long_min_from, long_sec_from, "Longitude from", :longitude)
    validate(long_deg_to, long_min_to, long_sec_to, "Longitude to", :longitude)
    @record
  end

  #TODO: fix up invalid for field == 0
  def validate(deg, min, sec, field_name, type)
    if not_empty?(deg)
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
      if not_empty?(min) || not_empty?(sec)
        @record = "Enter degrees for #{field_name}."
      end
    end

    # sec without min is invalid
    if not_empty?(sec) && empty?(min)
      @record = "Enter minutes for #{field_name}."
    end
  #  # sec/min not empty - check for year
  #  if not_empty? deg
  #    if type.eql? :latitude and (deg > 90 or deg < 0)
  #      @record = "You have entered an invalid degree for #{field_name}."
  #    elsif type.eql? :longitude and (deg > 180 or deg < 0)
  #      @record = "You have entered an invalid degree for #{field_name}."
  #    elsif min > 60 or min < 0
  #      @record = "You have entered an invalid minute for #{field_name}."
  #    elsif sec > 60 or sec < 0
  #      @record = "You have entered an invalid second for #{field_name}."
  #    end
  #  #check that min is not empty if sec
  #elsif empty? min and not_empty? sec
  #    @record = "Enter minutes for #{field_name}."
  #  end
  #else
  #  if not_empty? min or not_empty? sec and empty? deg
  #    @record = "Enter degrees for #{field_name}."
  #  end
  end

  def empty? (str)
    not not_empty? (str)
  end

  def not_empty?(str)
    str != nil && str.to_i > 0
  end

end