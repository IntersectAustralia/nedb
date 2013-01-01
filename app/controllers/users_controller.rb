class UsersController < ApplicationController
  
  before_filter :authenticate_user!

  load_and_authorize_resource

  def index
    @users = User.deactivated_or_approved.paginate(:page => params[:page], :per_page => 30)
  end

  def show
  end
  
  def access_requests
    @users = User.pending_approval
  end
  
  def deactivate
    @user.deactivate
    redirect_to(@user, :notice => "The user has been deactivated.")
  end

  def activate
    @user.activate
    redirect_to(@user, :notice => "The user has been activated.")
  end

  def reject
    @user.reject_access_request
    @user.destroy
    redirect_to(access_requests_users_path, :notice => "The access request for #{@user.email} was rejected.")
  end

  def reject_as_spam
    @user.reject_access_request
    redirect_to(access_requests_users_path, :notice => "The access request for #{@user.email} was rejected and this email address will be permanently blocked.")
  end

  def edit_profile
    @profiles = Profile.by_name
  end

  def edit_approval
    @profiles = Profile.by_name
  end

  def update_profile
    if !params[:user][:profile_id].blank?
      @user.profile_id = params[:user][:profile_id]
      @user.save

      redirect_to(@user, :notice => "The profile for #{@user.email} was successfully updated.")
    else
      redirect_to(edit_profile_user_path(@user), :alert => "Please select a profile for the user.")
    end
  end

  def approve
    if !params[:user][:profile_id].blank?
      @user.profile_id = params[:user][:profile_id]
      @user.save
      @user.approve_access_request

      redirect_to(access_requests_users_path, :notice => "The access request for #{@user.email} was approved.")
    else
      redirect_to(edit_approval_user_path(@user), :alert => "Please select a profile for the user.")
    end
  end
end