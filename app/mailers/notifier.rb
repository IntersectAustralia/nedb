class Notifier < ActionMailer::Base
  
  def notify_user_of_approved_request(recipient)
    @user = recipient
    mail( :to => @user.email, 
          :from => APP_CONFIG['account_request_user_status_email_sender'], 
          :reply_to => APP_CONFIG['account_request_user_status_email_sender'], 
          :subject => Setting.instance.app_title + " - access request approved")
  end

  def notify_user_of_rejected_request(recipient)
    @user = recipient
    mail( :to => @user.email, 
          :from => APP_CONFIG['account_request_user_status_email_sender'], 
          :reply_to => APP_CONFIG['account_request_user_status_email_sender'], 
          :subject => Setting.instance.app_title + " - access request status")
  end

  # notifications for super users
  def notify_superusers_of_access_request(applicant)
    superusers_emails = Profile.get_superuser_emails
    @user = applicant
    mail( :to => superusers_emails,
          :from => APP_CONFIG['account_request_admin_notification_sender'],
          :reply_to => @user.email,
          :subject => Setting.instance.app_title + " - new access request")
  end

  def notify_superusers_of_user_feedback(applicant, feedback)
    superusers_emails = Profile.get_superuser_emails
    @user = applicant
    mail( :to => superusers_emails,
          :from => @user.email, 
          :reply_to => @user.email, 
          :subject => Setting.instance.app_title + " - feedback from #{@user.first_name} #{@user.last_name}",
          :body => feedback)
  end
  
  def notify_superusers_of_deaccession_request(specimen)
    superusers_emails = Profile.get_superuser_emails
    @specimen = specimen
    mail( :to => superusers_emails,
          :from => APP_CONFIG['new_deaccession_notification_sender'],
          :subject => Setting.instance.app_title + " - #{Setting.instance.specimen_prefix}#{specimen.id} has been flagged for deaccession")
  end
end
