class FormsController < ApplicationController

  before_filter :authenticate_user!
  load_and_authorize_resource :species
  load_and_authorize_resource :form, :through => :species

  def new

  end

  def edit

  end

  def create
    if @form.save
      redirect_to(@species, :notice => 'The form was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @form.update_attributes(params[:form])
      redirect_to(@species, :notice => 'The form was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @form.destroy
    redirect_to(@species, :notice => 'The form was successfully deleted.')
  end
end
