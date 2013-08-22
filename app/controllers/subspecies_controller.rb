class SubspeciesController < ApplicationController

  before_filter :authenticate_user!
  load_and_authorize_resource :species
  load_and_authorize_resource :subspecies, :through => :species

  def new
    @species = Species.find(params[:species_id])
    @subspecies = Subspecies.new
  end

  def edit
    @species = Species.find(params[:species_id])
    @subspecies = Subspecies.find(params[:id])
  end

  def create
    if @subspecies.save
      redirect_to(@species, :notice => 'The subspecies was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @subspecies.update_attributes(params[:subspecies])
      redirect_to(@species, :notice => 'The subspecies was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @subspecies.destroy
    redirect_to(@species, :notice => 'The subspecies was successfully deleted.')
  end
end
