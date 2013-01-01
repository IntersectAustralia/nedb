When /^I attach an image file$/ do
  attach_file("Image", File.join(Rails.root.to_s, 'features', 'upload-files', 'picture.jpg'))
end

When /^I attach a huge image file$/ do
  attach_file("Image", File.join(Rails.root.to_s, 'features', 'upload-files', 'hugepicture.jpg'))
end

When /^I have a specimen image$/ do
  @created_specimen = Factory(:specimen)
  Factory(:specimen_image, :specimen => @created_specimen, :user_id => User.first.id)
end

When /^I have a specimen image with a Description "([^\"]*)" and filename "([^\"]*)" and uploader "([^\"]*)" with profile "([^\"]*)"$/ do |description, filename, email, profile|
  @created_specimen = Factory(:specimen)
  
  user = Factory(:user, :email => email, :password => "Pas$w0rd", :status => 'A')
  profile = Profile.where(:name => profile).first
  user.profile_id = profile.id
  user.save!

  @created_specimen_image = Factory(:specimen_image,
                                    :description => description,
                                    :image_file_name =>  filename,
                                    :user_id => user.id,
                                    :specimen => @created_specimen)
end

When /^I have a specimen image with a Description "([^\"]*)" and filename "([^\"]*)" and uploader "([^\"]*)"$/ do |description, filename, email|
  @created_specimen = Factory(:specimen)

  user = User.where(:email => email).first
  if !user
    user = Factory(:user, :email => email, :password => "Pas$w0rd", :status => 'A')
  end

  @created_specimen_image = Factory(:specimen_image,
                                    :description => description,
                                    :image_file_name =>  filename,
                                    :user_id => user.id,
                                    :specimen => @created_specimen)
end

Then /^I should see no images$/ do
  all('#images span.image').count.should eq(0)
end

And /^I should see upload metadata with user "([^\"]*)"$/ do |uploader|
  uploaded = "Uploaded by #{uploader} on #{Date.today.strftime("%d/%m/%Y")}"
  page.should have_content(uploaded)
end
