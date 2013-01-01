class SpeciesController < ApplicationController

  before_filter :authenticate_user!
  load_and_authorize_resource :except => [:index, :autocomplete_plant_name]

  def index
    # CanCan has a bug that make it not work on uncountable model names, so we have to manually authorize instead
    authorize! :read, Species

    if params[:reset]
      session.delete(:species_search_term)
    end

    if params[:search] || session[:species_search_term]
      term = if params[:search]
        params[:search]
      else
        session[:species_search_term]
      end
      @species = Species.free_text_search(term).paginate(:page => params[:page], :per_page => 30)
      @search_term = term
      session[:species_search_term] = term
    end

    render :action => "index"
  end

  def show

  end

  def new

  end

  def edit

  end

  def create
    if @species.save
      redirect_to(@species, :notice => 'Species was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @species.update_attributes(params[:species])
      redirect_to(@species, :notice => 'Species was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @species.destroy
    redirect_to(species_index_url, :notice => 'Species was successfully deleted.')
  end

  def autocomplete_plant_name
    term = params[:term]
    if !term.blank?
      level = params[:level]
      items = Species.autocomplete_plant_name(level, term)
    else
      items = {}
    end

    render :json => json_for_autocomplete(items, level)
  end

  private
  
  def json_for_autocomplete(items, method)
    items.collect {|i| {"id" => i.id, "label" => i.send(method), "value" => i.send(method)}}
  end

end
