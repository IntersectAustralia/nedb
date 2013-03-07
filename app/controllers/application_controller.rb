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

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: :render_500
    rescue_from ActionController::UnknownController, with: :render_404
    rescue_from ActionController::UnknownAction, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404

    rescue_from ActiveRecord::RecordInvalid, with: :render_422
    rescue_from ActiveRecord::RecordNotSaved, with: :render_422
    rescue_from ActionController::InvalidAuthenticityToken, with: :render_422
  end

  def routing_error
    flash[:alert] = "The page #{root_url}#{params[:a]} doesn't exist"
    redirect_to root_path
  end

  def render_404(exception)
    Rails.logger.error exception
    respond_to do |format|
      format.json {
        render :json => {"error" => 'Not found'}, :status => 404
      }
      format.html {
        flash[:alert] = exception.message
        redirect_to root_path
      }
    end
  end

  def render_422(exception)
    logger.info exception.backtrace.join("\n")
    respond_to do |format|
      format.html { render template: 'errors/422', layout: nil, status: 422 }
      format.all { render nothing: true, status: 422 }
    end
  end

  def render_500(exception)
    logger.info exception.backtrace.join("\n")
    respond_to do |format|
      format.html { render template: 'errors/500', layout: nil, status: 500 }
      format.all { render nothing: true, status: 500 }
    end
  end

end
