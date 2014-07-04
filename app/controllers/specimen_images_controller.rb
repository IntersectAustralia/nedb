
class SpecimenImagesController < ApplicationController

  before_filter :authenticate_user!
  load_and_authorize_resource :specimen
  load_and_authorize_resource :specimen_image, :through => :specimen

  def new
    # @specimen_image loaded by cancan
  end

  def show
    # @specimen_image loaded by cancan
  end

  def destroy
    @specimen_image.destroy
    @specimen.update_attribute(:needs_review, cannot?(:create_not_needing_review, @specimen))
    redirect_to(@specimen, :notice => 'The image was successfully deleted.')
  end

  def display_image
    style = params[:style].to_sym
    send_file @specimen_image.image.path(style), :type => @specimen_image.image_content_type, :disposition => 'inline'
  end

  def download
    send_file @specimen_image.image.path, :type => @specimen_image.image_content_type
  end

  def create
    @specimen_image.user_id = current_user.id
    if @specimen_image.save
      @specimen.update_attribute(:needs_review, cannot?(:create_not_needing_review, @specimen))
      @specimen.specimen_images.push(@specimen_image)
      redirect_to(@specimen, :notice => "The specimen image was uploaded successfully.")
    else
      render :action => 'new'
    end
  end

  def edit
    # @specimen_image loaded by cancan
  end

  def update
    # @specimen_image loaded by cancan
    if @specimen_image.update_attributes(params[:specimen_image])
      @specimen.update_attribute(:needs_review, cannot?(:create_not_needing_review, @specimen))
      redirect_to(specimen_specimen_image_path(@specimen, @specimen_image), :notice => 'The specimen image description was successfully updated.')
    else
      render :action => 'edit'
    end
  end
end
