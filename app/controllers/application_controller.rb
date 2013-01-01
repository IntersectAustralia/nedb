class ApplicationController < ActionController::Base
  protect_from_forgery

  # Overwriting the sign_out redirect path method to go to the home page after logout
  def after_sign_out_path_for(resource_or_scope)
    # remove session info for specimen fields before signing out
    session.delete(:previous_values)
    session.delete(:previous_secondary_collector_ids)
    root_path
  end


  # catch access denied and redirect to the home page
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end
  
end
