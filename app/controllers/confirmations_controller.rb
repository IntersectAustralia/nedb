class ConfirmationsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :load_people_and_herbaria, :only => [:show, :new, :edit, :create, :update]
  
  load_and_authorize_resource :specimen
  load_and_authorize_resource :determination
  load_and_authorize_resource :confirmation, :through => :specimen
  
  def new
    # @confirmation = Confirmation.new
  end

  def edit
    # @confirmation is loaded by CanCan
  end

  def create
    @determination = Determination.find(params[:determination_id])
    @confirmation = @determination.create_confirmation(params[:confirmation])
    @confirmation.legacy = false #any new records created will not be legacy

    if @confirmation.save
      redirect_to(@specimen, :notice => 'Confirmation was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    # @confirmation is loaded by CanCan

    if @confirmation.update_attributes(params[:confirmation])
      redirect_to(@specimen, :notice => 'Confirmation was successfully updated.')
    else
      render :action => "edit"
    end
  end

  private
 
  def load_people_and_herbaria
    @all_people = Person.all
    @all_herbaria = Herbarium.all
  end

end
