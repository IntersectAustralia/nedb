class SearchDateValidator < ActiveModel::Validator

  def initialize(search_params)
    @search_params = search_params.nil? ? nil : search_params
  end

  def validate_dates
    created_at_year_from = @search_params[:created_at_from_year].to_i
    created_at_month_from = @search_params[:created_at_from_month].to_i
    created_at_day_from = @search_params[:created_at_from_day].to_i
    created_at_year_to = @search_params[:created_at_to_year].to_i
    created_at_month_to = @search_params[:created_at_to_month].to_i
    created_at_day_to = @search_params[:created_at_to_day].to_i


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

    @messages = []

    validate(created_at_year_from, created_at_month_from, created_at_day_from, 'Creation date from')
    validate(created_at_year_to, created_at_month_to, created_at_day_to, 'Creation date to')
    compare_dates(created_at_year_from, created_at_month_from, created_at_day_from,
                  created_at_year_to, created_at_month_to, created_at_day_to, 'Creation date') if @messages.empty?

    validate(collection_year_from, collection_month_from, collection_day_from, 'Collection date from')
    validate(collection_year_to, collection_month_to, collection_day_to, 'Collection date to')
    compare_dates(collection_year_from, collection_month_from, collection_day_from,
                  collection_year_to, collection_month_to, collection_day_to, 'Collection date') if @messages.empty?

    validate(determination_year_from, determination_month_from, determination_day_from, 'Determination date from')
    validate(determination_year_to, determination_month_to, determination_day_to, 'Determination date to')
    compare_dates(determination_year_from, determination_month_from, determination_day_from,
                  determination_year_to, determination_month_to, determination_day_to, 'Determination date') if @messages.empty?
    @messages.empty? ? nil : @messages.join("<br>").html_safe #map { |a| "<div>#{a}</div>" }.join().html_safe
  end

  def validate(year, month, day, field_name)
    has_day = not_empty?(day)
    has_month = not_empty?(month)
    has_year = not_empty?(year)

    if has_day || has_month || has_year
      begin
        DateTime.strptime("#{day}/#{month}/#{year}", "%d/%m/%Y")
      rescue
        if not has_month
          @messages << "Enter a month for #{field_name}."
        elsif month < 1 or month > 13
          @messages << "You have entered an invalid month for #{field_name}."
        end
        days_in_month = days_in_month(month, year)
        if day > days_in_month || day < 1
          @messages << "You have entered an invalid day for the given month for #{field_name}."
        end
        if not has_year
          @messages << "Enter a year for #{field_name}."
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

  def empty?(str)
    not not_empty?(str)
  end

  def not_empty?(str)
    str != nil && str.to_i > 0
  end

  def compare_dates(year_from, month_from, day_from, year_to, month_to, day_to, field_name)
    date_from = date_string_from(year_from, month_from, day_from)
    date_to = date_string_to(year_to, month_to, day_to)

    if date_from != 0 and date_to != 0 and date_from > date_to
      @messages << "#{field_name} to cannot precede the #{field_name} from."
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