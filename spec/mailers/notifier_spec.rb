require "spec_helper"

describe Notifier do
  
  describe "Email notifications to users should be sent" do
    it "should send mail to user if access request approved" do
      address = 'user@email.org'
      user = FactoryGirl.create(:user, :status => "A", :email => address)
      email = Notifier.notify_user_of_approved_request(user).deliver
  
      # check that the email has been queued for sending
      ActionMailer::Base.deliveries.empty?.should eq(false) 
      email.to.should eq([address])
      email.subject.should eq("N.C.W. Beadle Herbarium - access request approved")
    end

    it "should send mail to user if access request denied" do
      address = 'user@email.org'
      user = FactoryGirl.create(:user, :status => "A", :email => address)
      email = Notifier.notify_user_of_rejected_request(user).deliver
  
      # check that the email has been queued for sending
      ActionMailer::Base.deliveries.empty?.should eq(false) 
      email.to.should eq([address])
      email.subject.should eq("N.C.W. Beadle Herbarium - access request status")
    end
  end

  describe "Notification to superusers when new access request created"
  it "should send the right email" do
    address = 'user@email.org'
    user = FactoryGirl.create(:user, :status => "U", :email => address)
    Profile.should_receive(:get_superuser_emails) { ["super1@intersect.org.au", "super2@intersect.org.au"] }
    email = Notifier.notify_superusers_of_access_request(user).deliver

    # check that the email has been queued for sending
    ActionMailer::Base.deliveries.empty?.should eq(false)
    email.subject.should eq("N.C.W. Beadle Herbarium - new access request")
    email.to.should eq(["super1@intersect.org.au", "super2@intersect.org.au"])
  end

  describe "Notification to superusers on feedback" do
    it "should send the right email when feedback created" do
      applicant = FactoryGirl.create(:user, :first_name => "Fred", :last_name => "Bloggs", :email => "fred@intersect.org.au")
      Profile.should_receive(:get_superuser_emails) { ["super1@intersect.org.au", "super2@intersect.org.au"] }
      email = Notifier.notify_superusers_of_user_feedback(applicant, "Some feedback").deliver

      ActionMailer::Base.deliveries.empty?.should eq(false)
      email.subject.should eq("N.C.W. Beadle Herbarium - feedback from Fred Bloggs")
      email.from.should eq(["fred@intersect.org.au"])
      email.to.should eq(["super1@intersect.org.au", "super2@intersect.org.au"])
      email.reply_to.should eq(["fred@intersect.org.au"])
      email.body.should eq("Some feedback")
    end
  end
  
  describe "Notification to superusers on deaccession" do
    it "should send the right email when deaccession requested" do
      specimen = FactoryGirl.create(:specimen)
      Profile.should_receive(:get_superuser_emails) { ["super1@intersect.org.au", "super2@intersect.org.au"] }
      email = Notifier.notify_superusers_of_deaccession_request(specimen).deliver

      ActionMailer::Base.deliveries.empty?.should eq(false)
      email.subject.should eq("N.C.W. Beadle Herbarium - NE#{specimen.id} has been flagged for deaccession")
      email.from.should eq([APP_CONFIG['new_deaccession_notification_sender']])
      email.to.should eq(["super1@intersect.org.au", "super2@intersect.org.au"])
    end
  end
      
end
