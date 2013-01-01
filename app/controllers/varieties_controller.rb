class VarietiesController < ApplicationController

  before_filter :authenticate_user!
  load_and_authorize_resource :species
  load_and_authorize_resource :variety, :through => :species

  def new

  end

  def edit

  end

  def create
    if @variety.save
      redirect_to(@species, :notice => 'The variety was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @variety.update_attributes(params[:variety])
      redirect_to(@species, :notice => 'The variety was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @variety.destroy
    redirect_to(@species, :notice => 'The variety was successfully deleted.')
  end
end
