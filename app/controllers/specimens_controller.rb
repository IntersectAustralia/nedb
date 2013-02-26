require 'csv'

class SpecimensController < ApplicationController

  before_filter :authenticate_user!
  before_filter :load_static_data, :only => [:new, :edit, :create, :update]
  before_filter :validate_search, :only => [:advanced_search]
  before_filter :load_static_search_data, :only => [:advanced_search]

  prawnto :prawn => {:left_margin => 10, :right_margin => 9, :top_margin => 6, :bottom_margin => 6, :page_size => "A4", :filename => "labels-.pdf"}

  load_and_authorize_resource

  def advanced_search_results
    @search = Specimen.search(params[:search])
  end

  def advanced_search
    @searchparams = {}
    params_hash = Marshal.load(Marshal.dump(params))
    unless params[:search].nil?
      @searchparams = params[:search]
      c_query = collection_date_query
      d_query = determination_date_query
      lat_query = latitude_query
      long_query = longitude_query
      delete_params(params_hash)
    end

    if @valid_search.nil?
      @search = Specimen.joins('LEFT OUTER JOIN specimen_dates ON specimens.id = specimen_dates.id LEFT OUTER JOIN det_dates ON specimens.id = det_dates.id LEFT OUTER JOIN specimen_coordinates ON specimens.id = specimen_coordinates.id')
                        .where(c_query)
                        .where(d_query)
                        .where(lat_query)
                        .where(long_query)
                        .search(params_hash[:search])
      q = @search.select("DISTINCT specimens.*").order('specimens.id')
      @adv_search_results = q.paginate(:page => params[:page])
      if !@has_params
        flash.now[:notice] = "Showing all #{@search.size} specimens."
      elsif @search.size >= 1
        flash.now[:notice] = "Found #{@search.size} matching specimens."
      else
        flash.now[:alert] = "No specimen was found."
      end
    else
      @search = Specimen.search(params[:search])
      @adv_search_results = []
      flash.now[:alert] = @valid_search
    end
    session[:search_results] = q.collect { |specimen| specimen.id }.sort
  end

  def validate_search
    @has_params = false
    if !params[:search].nil?
      #determine if
      params[:search].each_value do |value|
        @has_params |= !value.blank?
      end

      #validate date fields
      validator = SearchDateValidator.new(params[:search])
      @valid_search = validator.validate_dates
      #validate coordinate fields
      geo_validator = CoordinatesValidator.new(params[:search])
      @valid_search = geo_validator.validate_coordinates if @valid_search.nil?
    end
  end

  def search
    parser = SearchTermParser.new(params[:quick_search])

    if parser.is_blank?
      @specimens = Specimen.accessible_by(current_ability).order(:id)
      session[:search_results] = @specimens.collect { |specimen| specimen.id }.sort
      redirect_to(search_results_specimens_path, :notice => "Showing all #{@specimens.size} specimens.")
    elsif parser.accession_number_search?
      accession_number = parser.accession_number
      if Specimen.exists?(accession_number)
        @specimen = Specimen.find(accession_number)
        redirect_to(@specimen)
      else
        redirect_to(root_path, :alert => "No specimen was found with accession number #{accession_number}")
      end
    else
      @specimens = Specimen.free_text_search(parser.text_search)
      # ideally we would do this with the accessible_by scope method of CanCan, but our search is too complex, so we just filter out here
      @specimens = filter_out_deaccessioned(@specimens) unless can?(:view_deaccessioned, Specimen)

      if (@specimens.size > 1)
        session[:search_results] = @specimens.collect { |specimen| specimen.id }.sort
        redirect_to(search_results_specimens_path, :notice => "Found #{@specimens.size} matching specimens.")
      elsif (@specimens.size == 1)
        @specimen = @specimens[0]
        redirect_to(@specimen)
      else
        redirect_to(root_path, :alert => "No specimen was found for text search '#{parser.text_search}'")
      end
    end
  end

  def latest
    @specimens = Specimen.order(:updated_at).last(40).reverse

    respond_to do |format|
      format.html { flash.now[:notice] = "Showing latest 40 specimens in descending order"}
      format.csv { export_results(@specimens.collect(&:id)) } # this will generate the CSV file of all search results
    end
  end

  def search_results
    search_result_ids = session[:search_results]

    respond_to do |format|
      format.html do # renders the search results page
        current_page = if params[:page]
                         Integer(params[:page])
                       else
                         1
                       end

        per_page = 30
        start_specimen_number = (current_page-1)*per_page

        search_results = search_result_ids[start_specimen_number, per_page].collect do |specimen_id|
          Specimen.find(specimen_id)
        end

        @search_results = WillPaginate::Collection.create(current_page, per_page, search_result_ids.size) do |pager|
          pager.replace(search_results)
        end

      end
      format.csv { export_results(search_result_ids) } # this will generate the CSV file of all search results
    end

  end

  def search_results_print_labels
    all_specimens = Specimen.find(session[:search_results])
    @specimens = all_specimens.find_all { |specimen| !specimen.determinations.empty? && specimen.has_labellable_items? }

    if @specimens.empty?
      redirect_to(search_results_specimens_path, :alert => 'No labels to print for these specimens.')
    else
      send_data(render_to_string(:action => 'labels'), :filename => "labels.pdf", :type => "application/pdf")
    end
  end

  def show
    @items = @specimen.items.ordered_by_type_name
    @determinations = @specimen.determinations.sort!
    @current_det = @specimen.current_determination
    @replicates = @specimen.replicates.ordered_by_code
    @specimen_images = @specimen.specimen_images
    @item_types = ItemType.all
  end

  def labels
    if @specimen.determinations.empty?
      redirect_to(@specimen, :alert => "Labels cannot be generated for this specimen as it does not have a determination.")
    elsif !@specimen.has_labellable_items?
      redirect_to(@specimen, :alert => "There are no labels to generate for this specimen. Try adding some specimen sheets or fruit items.")
    else
      @specimens = [@specimen]
      send_data(render_to_string, :filename => "labels.pdf", :type => "application/pdf")
    end
  end

  def new
    populate_with_values_from_last_time_or_defaults
  end

  def edit

  end

  def edit_replicates
    @all_herbaria = Herbarium.all
  end

  def create
    Specimen.remove_fullstops(params[:specimen])
    @specimen = Specimen.new(params[:specimen])

    unless params[:specimen][:id].to_i == 0
      @specimen.id = params[:specimen][:id]
    end

    @specimen.secondary_collectors = Person.find(params[:secondary_collector_ids]) if params[:secondary_collector_ids]
    @specimen.needs_review = cannot? :create_not_needing_review, @specimen
    @specimen.legacy = false #any new records created will not be legacy

    if @specimen.save
      save_values_for_next_time(params)
      redirect_to(@specimen, :notice => 'The specimen was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    Specimen.remove_fullstops(params[:specimen])
    params[:legacy] = @specimen.legacy

    if @specimen.update_attributes(params[:specimen])

      if params[:secondary_collector_ids]
        @specimen.secondary_collectors = Person.find(params[:secondary_collector_ids])
      else
        @specimen.secondary_collectors = []
      end
      @specimen.touch
      redirect_to(@specimen, :notice => 'The specimen was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def update_replicates
    params[:specimen] ||= {} #handle the case where nothing checked
    params[:specimen][:replicate_ids] ||= [] #handle the case where nothing checked

    @specimen.replicate_ids = params[:specimen][:replicate_ids]
    @specimen.touch
    @specimen.save
    redirect_to(@specimen, :notice => 'The replicates were successfully updated.')
  end

  def add_item
    item_type = ItemType.find(params[:item_type_id])
    @item = @specimen.items.create!(:item_type => item_type)
    redirect_to(@specimen, :notice => 'The item was successfully added.')
  end

  def request_deaccession
    @specimen.request_deaccession
    redirect_to(@specimen, :notice => 'The request for deaccession has been successful.')
  end

  def approve_deaccession
    @specimen.approve_deaccession
    redirect_to(@specimen, :notice => 'The deaccession has been approved.')
  end

  def unflag_deaccession
    @specimen.unflag_deaccession
    redirect_to(@specimen, :notice => 'The deaccession has been unflagged.')
  end

  def needing_review
    @specimens = Specimen.needing_review
  end

  def mark_as_reviewed
    @specimen.mark_as_reviewed
    redirect_to(@specimen, :notice => 'The specimen has been marked as reviwed.')
  end

  def download_zip
    file_name = "NE#{@specimen.id}_images.zip"
    @specimen.with_images_in_temp_zip_file do |zip_file|
      zip_data = File.read zip_file
      send_data zip_data, type: 'application/zip', filename: file_name
    end
  end

  private

  def load_static_data
    @all_people = Person.all
    @countries = Country.alpha_order_with_australia_first
    @states = State.order(:name)
    @botanical_divisions = BotanicalDivision.order(:name)
  end

  def load_static_search_data
    @all_divisions = Species.select("DISTINCT species.division").order('species.division').where("species.division != ''")
    @all_class = Species.select("DISTINCT species.class_name").order('species.class_name').where("species.class_name != ''")
    @all_order = Species.select("DISTINCT species.order_name").order('species.order_name').where("species.order_name != ''")
    @all_family = Species.select("DISTINCT species.family").order('species.family').where("species.family != ''")
    @all_subfamily = Species.select("DISTINCT species.sub_family").order('species.sub_family').where("species.sub_family != ''")
    @all_genus = Species.select("DISTINCT species.genus").order('species.genus').where("species.genus != ''")
    @all_species = Species.select("DISTINCT species.name").order('species.name').where("species.name != ''")
    @all_subspecies = Subspecies.select("DISTINCT subspecies.subspecies").order('subspecies.subspecies').where("subspecies.subspecies != ''")
    @all_variety = Variety.select("DISTINCT varieties.variety").order('varieties.variety').where("varieties.variety != ''")
    @all_tribe = Species.select("DISTINCT species.tribe").order('species.tribe').where("species.tribe != ''")
    @all_people = Person.all
  end

  def filter_out_deaccessioned(specimens)
    specimens.select { |specimen| !specimen.deaccession_approved? }
  end

  def export_results(search_result_ids)
    # load most data eagerly to make the query more efficient
    eager_loads = {:collector => [], :determinations => [:determiners, :confirmation], :items => [], :secondary_collectors => []}
    search_results = Specimen.includes(eager_loads).find(search_result_ids, :order => "id")
    csv_file = CSV.generate(:col_sep => ",") do |csv|
      # header row
      csv << Specimen.get_header

      # data rows
      search_results.each do |s|
        csv << s.add_csv_row
      end
    end

    # send the file to the browser
    send_data csv_file, :type => 'text/csv; charset=utf-16 header=present', :disposition => "attachment; filename=search_results.csv"
  end

  def save_values_for_next_time(params)
    specimen_params = params[:specimen]
    saved_values = specimen_params.slice("collector_id",
                                         "collection_date_day",
                                         "collection_date_month",
                                         "collection_date_year",
                                         "secondary_collector_ids[]",
                                         "country",
                                         "state",
                                         "botanical_division",
                                         "locality_description",
                                         "latitude_degrees",
                                         "latitude_minutes",
                                         "latitude_seconds",
                                         "latitude_hemisphere",
                                         "longitude_degrees",
                                         "longitude_minutes",
                                         "longitude_seconds",
                                         "longitude_hemisphere",
                                         "altitude",
                                         "point_data",
                                         "datum",
                                         "topography",
                                         "aspect",
                                         "substrate",
                                         "vegetation")
    session[:previous_values] = saved_values
    session[:previous_secondary_collector_ids] = params[:secondary_collector_ids]
  end

  def populate_with_values_from_last_time_or_defaults
    if session[:previous_values]
      @specimen = Specimen.new(session[:previous_values])
      #changed to find_all_by_id in case people are deleted from database
      @specimen.secondary_collectors = Person.find_all_by_id(session[:previous_secondary_collector_ids]) if session[:previous_secondary_collector_ids]
    else
      @specimen.latitude_hemisphere = "S"
      @specimen.longitude_hemisphere = "E"
      australia = Country.find_australia
      @specimen.country = australia.name if australia
    end
  end

  def delete_params(params_hash)
    params_hash[:search].delete :collection_date_year_greater_than_or_equal_to
    params_hash[:search].delete :collection_date_month_greater_than_or_equal_to
    params_hash[:search].delete :collection_date_day_greater_than_or_equal_to
    params_hash[:search].delete :collection_date_year_less_than_or_equal_to
    params_hash[:search].delete :collection_date_month_less_than_or_equal_to
    params_hash[:search].delete :collection_date_day_less_than_or_equal_to

    params_hash[:search].delete :determinations_determination_date_year_greater_than_or_equal_to
    params_hash[:search].delete :determinations_determination_date_month_greater_than_or_equal_to
    params_hash[:search].delete :determinations_determination_date_day_greater_than_or_equal_to
    params_hash[:search].delete :determinations_determination_date_year_less_than_or_equal_to
    params_hash[:search].delete :determinations_determination_date_month_less_than_or_equal_to
    params_hash[:search].delete :determinations_determination_date_day_less_than_or_equal_to

    params_hash[:search].delete :latitude_degrees_greater_than_or_equal_to
    params_hash[:search].delete :latitude_minutes_greater_than_or_equal_to
    params_hash[:search].delete :latitude_seconds_greater_than_or_equal_to
    params_hash[:search].delete :latitude_degrees_less_than_or_equal_to
    params_hash[:search].delete :latitude_minutes_less_than_or_equal_to
    params_hash[:search].delete :latitude_seconds_less_than_or_equal_to

    params_hash[:search].delete :longitude_degrees_greater_than_or_equal_to
    params_hash[:search].delete :longitude_minutes_greater_than_or_equal_to
    params_hash[:search].delete :longitude_seconds_greater_than_or_equal_to
    params_hash[:search].delete :longitude_degrees_less_than_or_equal_to
    params_hash[:search].delete :longitude_minutes_less_than_or_equal_to
    params_hash[:search].delete :longitude_seconds_less_than_or_equal_to
  end

  def longitude_query
    degrees_from = params[:search][:longitude_degrees_greater_than_or_equal_to]
    minutes_from = params[:search][:longitude_minutes_greater_than_or_equal_to]
    seconds_from = params[:search][:longitude_seconds_greater_than_or_equal_to]
    degrees_to = params[:search][:longitude_degrees_less_than_or_equal_to]
    minutes_to = params[:search][:longitude_minutes_less_than_or_equal_to]
    seconds_to = params[:search][:longitude_seconds_less_than_or_equal_to]

    query_object = "specimen_coordinates.longitude"
    coordinate_param = coordinate_search_format(degrees_from, minutes_from, seconds_from, degrees_to, minutes_to, seconds_to)
    coordinate_query(coordinate_param, query_object)
  end

  def latitude_query
    degrees_from = params[:search][:latitude_degrees_greater_than_or_equal_to]
    minutes_from = params[:search][:latitude_minutes_greater_than_or_equal_to]
    seconds_from = params[:search][:latitude_seconds_greater_than_or_equal_to]
    degrees_to = params[:search][:latitude_degrees_less_than_or_equal_to]
    minutes_to = params[:search][:latitude_minutes_less_than_or_equal_to]
    seconds_to = params[:search][:latitude_seconds_less_than_or_equal_to]

    query_object = "specimen_coordinates.latitude"
    coordinate_param = coordinate_search_format(degrees_from, minutes_from, seconds_from, degrees_to, minutes_to, seconds_to)
    coordinate_query(coordinate_param, query_object)
  end

  def coordinate_search_format(degrees_from, minutes_from, seconds_from, degrees_to, minutes_to, seconds_to)
    params = []
    if !degrees_from.blank? && minutes_from.blank? && seconds_from.blank?
      params[0] = degrees_from.to_f
    elsif !degrees_from.blank? && !minutes_from.blank? && seconds_from.blank?
      params[0] = degrees_from.to_f + ((minutes_from.to_f * 60) / 3600)
    else
      params[0] = degrees_from.to_f + ((minutes_from.to_f * 60 + seconds_from.to_f) / 3600)
    end

    if !degrees_to.blank? && minutes_to.blank? && seconds_to.blank?
      params[1] = degrees_to.to_f + 1
    elsif !degrees_to.blank? && !minutes_to.blank? && seconds_to.blank?
      params[1] = degrees_to.to_f + ((minutes_to.to_f * 60) / 3600)
    else
      params[1] = degrees_to.to_f + ((minutes_to.to_f * 60 + seconds_to.to_f) / 3600)
    end
    #hacky workaround to match pgsql values
    params[0] = params[0].to_f.round(13)
    params[1] = params[1].to_f.round(13)
    params
  end

  def coordinate_query(params, query_object)
    if params[0] == 0 && params[1] == 0
      date_query = ""
    elsif params[0] != 0 && params[1] == 0
      date_query = "#{query_object} >= #{params[0]}"
    elsif params[0] == 0 && params[1] != 0
      date_query = "#{query_object} <= #{params[1]}"
    else
      date_query = "#{query_object} BETWEEN #{params[0]} AND #{params[1]}"
    end
  end

  def collection_date_query
    year_from = params[:search][:collection_date_year_greater_than_or_equal_to]
    month_from = params[:search][:collection_date_month_greater_than_or_equal_to]
    day_from = params[:search][:collection_date_day_greater_than_or_equal_to]
    year_to = params[:search][:collection_date_year_less_than_or_equal_to]
    month_to = params[:search][:collection_date_month_less_than_or_equal_to]
    day_to = params[:search][:collection_date_day_less_than_or_equal_to]

    query_object = "specimen_dates.collection_date"
    date_param = date_search_format(year_from, month_from, day_from, year_to, month_to, day_to)
    date_query(date_param, query_object)
  end

  def determination_date_query
    year_from = params[:search][:determinations_determination_date_year_greater_than_or_equal_to]
    month_from = params[:search][:determinations_determination_date_month_greater_than_or_equal_to]
    day_from = params[:search][:determinations_determination_date_day_greater_than_or_equal_to]
    year_to = params[:search][:determinations_determination_date_year_less_than_or_equal_to]
    month_to = params[:search][:determinations_determination_date_month_less_than_or_equal_to]
    day_to = params[:search][:determinations_determination_date_day_less_than_or_equal_to]

    query_object = "det_dates.date"
    date_param = date_search_format(year_from, month_from, day_from, year_to, month_to, day_to)
    date_query(date_param, query_object)
  end

  def date_search_format(year_from, month_from, day_from, year_to, month_to, day_to)
    date_param = []
    if !year_from.blank? && month_from.blank? && day_from.blank?
      date_param[0] = "%4d%02d%02d" % [year_from.to_i, 1, 1]
    elsif !year_from.blank? && !month_from.blank? && day_from.blank?
      date_param[0] = "%4d%02d%02d" % [year_from.to_i, month_from.to_i, 1]
    else
      date_param[0] = "%4d%02d%02d" % [year_from.to_i, month_from.to_i, day_from.to_i]
    end

    if !year_to.blank? && month_to.blank? && day_to.blank?
      date_param[1] = "%4d%02d%02d" % [year_to.to_i, 12, 31]
    elsif !year_to.blank? && !month_to.blank? && day_to.blank?
      date_param[1] = "%4d%02d%02d" % [year_to.to_i, month_to.to_i, days_in_month(month_to.to_i, year_to.to_i)]
    else
      date_param[1] = "%4d%02d%02d" % [year_to.to_i, month_to.to_i, day_to.to_i]
    end
    date_param[0] = date_param[0].to_i
    date_param[1] = date_param[1].to_i
    date_param
  end

  def date_query(date_param, query_object)
    if date_param[0] == 0 && date_param[1] == 0
      date_query = ""
    elsif date_param[0] != 0 && date_param[1] == 0
      date_query = "#{query_object} >= #{date_param[0]}"
    elsif date_param[0] == 0 && date_param[1] != 0
      date_query = "#{query_object} <= #{date_param[1]}"
    else
      date_query = "#{query_object} BETWEEN #{date_param[0]} AND #{date_param[1]}"
    end
  end

  def days_in_month(month, year)
    if month == 2
      !year.nil? && (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0)) ?  29 : 28
    elsif month <= 7
      month % 2 == 0 ? 30 : 31
    else
      month % 2 == 0 ? 31 : 30
    end
  end

end

class SearchTermParser

  def initialize(raw_search_term)
    @raw_search_term = raw_search_term.nil? ? nil : raw_search_term.strip
  end

  def is_blank?
    @raw_search_term.blank?
  end

  def accession_number_search?
    !accession_number.nil?
  end

  def accession_number
    if @raw_search_term =~ /^NE[0-9]+\.[0-9a-zA-Z]+$/
      # its in the format NE[accession_no].[item_number or rep code]
      dot_location = @raw_search_term.index(".")
      return @raw_search_term[2..(dot_location - 1)]
    elsif @raw_search_term =~ /^NE[0-9]+$/
      # its in the format NE[accession_no]
      return @raw_search_term[2, @raw_search_term.length]
    elsif @raw_search_term =~ /^[0-9]+$/
      # its just the number
      return @raw_search_term
    else
      return nil
    end
  end

  def text_search
    @raw_search_term
  end

end
