class UserRegistersController < Devise::RegistrationsController

  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy, :edit_password, :update_password, :feedback, :send_feedback]

  # Override the create method in the RegistrationsController
  def create
    build_resource

    if resource.valid?
      resource.save
      Notifier.notify_superusers_of_access_request(resource)

      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        redirect_to root_path
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
  
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    if resource.update_attributes(params[resource_name])
      if is_navigational_format?
        if resource.respond_to?(:pending_reconfirmation?) && resource.pending_reconfirmation?
          flash_key = :update_needs_confirmation
        end
        set_flash_message :notice, flash_key || :updated
      end
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
  
  def edit_password
    render_with_scope :edit_password
  end

  def update_password
    if resource.update_password(params[resource_name])
      set_flash_message :notice, :updated_password
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
    redirect_to(root_path, :notice => :send_feedback)
  end

end
