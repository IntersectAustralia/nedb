require 'will_paginate/array'

class HerbariaController < ApplicationController

  before_filter :authenticate_user!

  load_and_authorize_resource

  def index

    search_result_ids = session[:herbaria_search_results]

    if search_result_ids.present?
      current_page = if params[:page]
                       Integer(params[:page])
                     else
                       1
                     end

      per_page = 30
      start_herbarium_number = (current_page-1)*per_page

      search_results = search_result_ids[start_herbarium_number, per_page].collect do |specimen_id|
        Herbarium.find(specimen_id)
      end

      @herbaria = WillPaginate::Collection.create(current_page, per_page, search_result_ids.size) do |pager|
        pager.replace(search_results)
      end

      session.delete(:herbaria_search_results)

    else
      @herbaria = Herbarium.ordered_by_code.paginate(:page => params[:page], :per_page => 30)

    end

  end

  def new
  end

  def edit
  end

  def search
    search_term = params[:quick_herbaria_search]

    if search_term.blank?
      @herbaria = Herbarium.ordered_by_code.accessible_by(current_ability)
      session[:herbaria_search_results] = @herbaria.collect { |specimen| specimen.id }
      redirect_to(herbaria_path, :notice => "Showing all #{@herbaria.size} herbaria.")
    else
      @herbaria = Herbarium.free_text_search(search_term)

      if (@herbaria.size > 1)
        session[:herbaria_search_results] = @herbaria.collect { |herbarium| herbarium.id }
        redirect_to(herbaria_path, :notice => "Found #{@herbaria.size} matching herbaria.")
      elsif (@herbaria.size == 1)
        @herbarium = @herbaria[0]
        if can?(:update, Herbarium)
          redirect_to(edit_herbarium_path(@herbarium), :notice => "Found 1 matching herbarium.")
        else
          session[:herbaria_search_results] = [@herbarium.id]
          redirect_to(herbaria_path, :notice => "Found 1 matching herbarium.")
        end
      else
        redirect_to(herbaria_path, :alert => "No herbaria was found for text search '#{search_term}'")
      end
    end

  end

  def create
    if @herbarium.save
      redirect_to(herbaria_url, :notice => 'Herbarium was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @herbarium.update_attributes(params[:herbarium])
      redirect_to(herbaria_url, :notice => 'Herbarium was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def autocomplete_herbarium_name
    term = params[:term]
    items = term.present? ? Herbarium.autocomplete_herbarium_name(term) : {}

    render :json => json_for_autocomplete(items)
  end

  private

  def json_for_autocomplete(items)
    items.collect do |i|
      {"id" => i.id, "label" => "#{i.code} - #{i.name}", "value" => i.code}
    end
  end


end
