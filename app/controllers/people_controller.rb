class PeopleController < ApplicationController

  before_filter :authenticate_user!
  before_filter :load_herbaria, :only => [:new, :edit, :create, :update]

  load_and_authorize_resource

  def index
    @people = Person.paginate(:page => params[:page], :per_page => 30)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @person.save
      redirect_to(people_url, :notice => 'Person was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @person.update_attributes(params[:person])
      redirect_to(people_url, :notice => 'Person was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    begin
      @person.destroy
      redirect_to(people_url, :notice => 'Person was successfully deleted.')
    rescue ActiveRecord::DeleteRestrictionError
      redirect_to(:back, :alert => 'Person could not be deleted as it is still being referenced.')
    end
  end

  def search
    search_term = params[:people_search]
    if search_term.blank?
      @people = Person.all
      session[:search_results] = @people.collect { |person| person.id }.sort
      redirect_to people_path, :notice => "Showing all #{@people.size} person(s)."
    else
      @people = Person.scoped(:select => 'people.*',
                              :conditions => ["first_name || last_name || initials ILIKE ?", "%#{search_term}%"]).all
      if @people.size > 1
        session[:search_results] = @people.collect { |person| person.id }.sort
        redirect_to search_results_people_path, :notice => "Found #{@people.size} matching person(s)"
      elsif @people.size == 1
        redirect_to(@people)
      else
        redirect_to people_path, :alert => "No person was found for text search '#{search_term}'"
      end
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
        start_person_number = (current_page-1)*per_page

        #get everyone by ids provided
        @results = search_result_ids.collect do |id|
          Person.find(id)
        end
        #sort the results before paginating them
        @results.sort_by! {|person| [person.last_name, person.initials]}
        #return the results based on page # and per_page
        search_results = @results[start_person_number, per_page]

        @search_results = WillPaginate::Collection.create(current_page, per_page, search_result_ids.size) do |pager|
          pager.replace(search_results)
        end
      end
    end
  end

  private

  def load_herbaria
    @herbaria = Herbarium.ordered_by_code
  end
end
