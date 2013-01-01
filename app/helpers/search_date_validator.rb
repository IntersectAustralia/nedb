class SearchDateValidator < ActiveModel::Validator

  def initialize(search_params)
    @search_params = search_params.nil? ? nil : search_params
  end

  def validate_dates
    collection_year_from = @search_params[:collection_date_year_greater_than_or_equal_to].to_i
    collection_month_from = @search_params[:collection_date_month_greater_than_or_equal_to].to_i
    collection_day_from = @search_params[:collection_date_day_greater_than_or_equal_to].to_i
    collection_year_to = @search_params[:collection_date_year_less_than_or_equal_to].to_i
    collection_month_to = @search_params[:collection_date_month_less_than_or_equal_to].to_i
    collection_day_to = @search_params[:collection_date_day_less_than_or_equal_to].to_i


    determination_year_from = @search_params[:determinations_determination_date_year_greater_than_or_equal_to].to_i
    determination_month_from = @search_params[:determinations_determination_date_month_greater_than_or_equal_to].to_i
    determination_day_from = @search_params[:determinations_determination_date_day_greater_than_or_equal_to].to_i
    determination_year_to = @search_params[:determinations_determination_date_year_less_than_or_equal_to].to_i
    determination_month_to = @search_params[:determinations_determination_date_month_less_than_or_equal_to].to_i
    determination_day_to = @search_params[:determinations_determination_date_day_less_than_or_equal_to].to_i


    validate(collection_year_from, collection_month_from, collection_day_from, 'Collection date from')
    validate(collection_year_to, collection_month_to, collection_day_to, 'Collection date to')
    compare_dates(collection_year_from, collection_month_from, collection_day_from,
                  collection_year_to, collection_month_to, collection_day_to, 'Collection date') if @record.nil?

    validate(determination_year_from, determination_month_from, determination_day_from, 'Determination date from')
    validate(determination_year_to, determination_month_to, determination_day_to, 'Determination date to')
    compare_dates(determination_year_from, determination_month_from, determination_day_from,
                  determination_year_to, determination_month_to, determination_day_to, 'Determination date') if @record.nil?
    @record
  end

  def validate(year, month, day, field_name)
    if empty? month and not_empty? day
      @record = "Enter a month for #{field_name}."
    else
      # if a day and month are included check if day is valid in given month
      if !empty? month and !empty? day
        days_in_month = days_in_month(month, year)
        if day > days_in_month
          @record = "You have entered an invalid day for the given month for #{field_name}."
        end
      end
    end
  else
    if not_empty? month or not_empty? day and empty? year
      @record = "Enter a year for #{field_name}."
      # check that the month field is not empty if a day is filled in
    elsif empty? month and not_empty? day
      @record = "Enter a month for #{field_name}."
    else
      # if a day and month are included check if day is valid in given month
      if !empty? month and !empty? day
        days_in_month = days_in_month(month, year)
        if day > days_in_month
          @record = "You have entered an invalid day for the given month for #{field_name}."
        end
      end
    end
  end

  private

  # from ActiveSupport::CoreExtensions::Time
  def days_in_month(month, year)
    if month == 2
      !year.nil? && (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0)) ?  29 : 28
    elsif month <= 7
      month % 2 == 0 ? 30 : 31
    else
      month % 2 == 0 ? 31 : 30
    end
  end

  def empty? (str)
    not not_empty? (str)
  end

  def not_empty?(str)
    str != nil && str.to_i > 0
  end

  def compare_dates(year_from, month_from, day_from, year_to, month_to, day_to, field_name)
    date_from = date_string_from(year_from, month_from, day_from)
    date_to = date_string_to(year_to, month_to, day_to)

    if date_from != 0 and date_to != 0 and date_from > date_to
      @record = "#{field_name} to cannot precede the #{field_name} from."
    end
  end

  def date_string_from(year_from, month_from, day_from)
    if year_from == 0 && month_from == 0 && day_from == 0
      date_string = 0
    elsif month_from == 0 && day_from == 0
      date_string = "%4d%02d%02d" % [year_from, 1, 1]
    elsif month_from != 0 && day_from == 0
      date_string = "%4d%02d%02d" % [year_from, month_from, 1]
    else
      date_string = "%4d%02d%02d" % [year_from, month_from, day_from]
    end
    date_string.to_i
  end

  def date_string_to(year_to, month_to, day_to)
    if year_to == 0 && month_to == 0 && day_to == 0
      date_string = 0
    elsif month_to == 0 && day_to == 0
      date_string =  "%4d%02d%02d" % [year_to, 12, 31]
    elsif month_to != 0 && day_to == 0
      date_string =  "%4d%02d%02d" % [year_to, month_to, days_in_month(month_to, year_to)]
    else
      date_string = "%4d%02d%02d" % [year_to, month_to, day_to]
    end
    date_string.to_i
  end

end