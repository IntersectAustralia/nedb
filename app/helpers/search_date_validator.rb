class SearchDateValidator < ActiveModel::Validator

  def initialize(search_params)
    @search_params = search_params.nil? ? nil : search_params
  end

  def validate_dates
    created_at_year_from = @search_params[:created_at_from_year]
    created_at_month_from = @search_params[:created_at_from_month]
    created_at_day_from = @search_params[:created_at_from_day]
    created_at_year_to = @search_params[:created_at_to_year]
    created_at_month_to = @search_params[:created_at_to_month]
    created_at_day_to = @search_params[:created_at_to_day]


    collection_year_from = @search_params[:collection_date_year_greater_than_or_equal_to]
    collection_month_from = @search_params[:collection_date_month_greater_than_or_equal_to]
    collection_day_from = @search_params[:collection_date_day_greater_than_or_equal_to]
    collection_year_to = @search_params[:collection_date_year_less_than_or_equal_to]
    collection_month_to = @search_params[:collection_date_month_less_than_or_equal_to]
    collection_day_to = @search_params[:collection_date_day_less_than_or_equal_to]

    confirmation_year = @search_params[:confirmations_confirmation_date_year_equals]
    confirmation_month = @search_params[:confirmations_confirmation_date_month_equals]
    confirmation_day = @search_params[:confirmations_confirmation_date_day_equals]


    determination_year_from = @search_params[:determinations_determination_date_year_greater_than_or_equal_to]
    determination_month_from = @search_params[:determinations_determination_date_month_greater_than_or_equal_to]
    determination_day_from = @search_params[:determinations_determination_date_day_greater_than_or_equal_to]
    determination_year_to = @search_params[:determinations_determination_date_year_less_than_or_equal_to]
    determination_month_to = @search_params[:determinations_determination_date_month_less_than_or_equal_to]
    determination_day_to = @search_params[:determinations_determination_date_day_less_than_or_equal_to]

    @messages = []

    created_date_from = validate(created_at_year_from, created_at_month_from, created_at_day_from, 'Creation date from')
    created_date_to = validate(created_at_year_to, created_at_month_to, created_at_day_to, 'Creation date to')
    compare_dates(created_date_from, created_date_to, 'Creation date') if @messages.empty?

    collection_date_from = validate(collection_year_from, collection_month_from, collection_day_from, 'Collection date from')
    collection_date_to = validate(collection_year_to, collection_month_to, collection_day_to, 'Collection date to')
    compare_dates(collection_date_from, collection_date_to, 'Collection date') if @messages.empty?

    validate(confirmation_year, confirmation_month, confirmation_day, 'Confirmation date')

    determination_date_from = validate(determination_year_from, determination_month_from, determination_day_from, 'Determination date from')
    determination_date_to = validate(determination_year_to, determination_month_to, determination_day_to, 'Determination date to')
    compare_dates(determination_date_from, determination_date_to, 'Determination date') if @messages.empty?
    @messages.empty? ? nil : @messages.join("<br>").html_safe
  end

  def validate(year, month, day, field_name)
    time_str = "#{day}/#{month}/#{year}"
    format_str = ""
    if /\d+\/\d+\/\d+/.match(time_str)
      format_str = "%d/%m/%Y"
    elsif /\/\d+\/\d+/.match(time_str)
      format_str = "/%m/%Y"
    elsif /\/\d+/.match(time_str)
      format_str = "//%Y"
    elsif /^\/\/$/.match(time_str)
      return nil
    end

    begin
      DateTime.strptime(time_str, format_str)
    rescue ArgumentError
      @messages << "Enter a valid date for #{field_name}"
    end
  end

  private

  def compare_dates(date_from, date_to, field_name)
    if date_from.present? and date_to.present? and date_from > date_to
      @messages << "#{field_name} to cannot precede the #{field_name} from."
    end
  end

end