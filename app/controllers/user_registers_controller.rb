class UserRegistersController < Devise::RegistrationsController

  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy, :edit_password, :update_password, :feedback, :send_feedback]

  # Override the create method in the RegistrationsController
  def create
    build_resource
    if resource.save
      flash[:notice] = "Thanks for requesting an account. You will receive an email when your request has been approved."
      
      # send the superadmin an email
      resource.notify_admin_by_email
      sign_in_and_redirect(resource_name, resource)
    else
      clean_up_passwords(resource)
      render_with_scope :new
    end
  end
  
  def update
    if resource.update_attributes(params[resource_name])
      set_flash_message :notice, :updated
      redirect_to after_update_path_for(resource)
    else
      clean_up_passwords(resource)
      render_with_scope :edit
    end
  end
  
  def edit_password
    render_with_scope :edit_password
  end

  def update_password
    if resource.update_password(params[resource_name])
      flash[:notice] = "Your password has been updated."
      redirect_to root_path
    else
      clean_up_passwords(resource)
      render_with_scope :edit_password
    end
  end

  def feedback
  end
  
  def send_feedback
    @user = current_user
    feedback = params[:feedback]
    @user.submit_feedback(feedback)
    redirect_to(root_path, :notice => "Your feedback has been submitted successfully")
  end

end
