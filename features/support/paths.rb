module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

    when /^the latest specimens page$/
      latest_specimens_path

    when /^the specimen page$/
      specimen_path(@created_specimen)

    when /^the specimen image page$/
      specimen_specimen_image_path(@created_specimen, @created_specimen.specimen_images.first)

    when /the new specimen page/
      new_specimen_path

    when /^the specimen page for "(.*)"$/
      specimen_path(@specimens[$1])
      
    when /^the edit specimen page for "(.*)"$/
      edit_specimen_path(@specimens[$1])
      
    when /^the edit replicates page for "(.*)"$/
      edit_replicates_specimen_path(@specimens[$1])
      
    when /^the view determination page for "(.*)"$/
      specimen_determination_path(@specimens[$1], @specimens[$1].determinations.first)
      
    when /^the create determination page for "(.*)"$/
      new_specimen_determination_path(@specimens[$1])

    when /^the edit determination page for "(.*)"$/
      edit_specimen_determination_path(@specimens[$1], @specimens[$1].determinations.first)

    when /^the download specimen image page for "(.*)"$/
      download_specimen_specimen_image_path(@specimens[$1], @specimens[$1].specimen_images.first)

    when /^the view specimen image page for "(.*)"$/
      specimen_specimen_image_path(@specimens[$1], @specimens[$1].specimen_images.first)

    when /^the edit specimen image page for "(.*)"$/
      edit_specimen_specimen_image_path(@specimens[$1], @specimens[$1].specimen_images.first)

    when /^the new specimen image page for "(.*)"$/
      new_specimen_specimen_image_path(@specimens[$1], @specimens[$1].specimen_images.first)

    when /^the create confirmation page for "(.*)"$/
      new_specimen_determination_confirmation_path(@specimens[$1], @specimens[$1].determinations.first)
      
    when /^the edit confirmation page for "(.*)"$/
      edit_specimen_determination_confirmation_path(@specimens[$1], @specimens[$1].confirmations.first.determination, @specimens[$1].confirmations.first)
      
    when /the login page/
      new_user_session_path

    when /the logout page/
      destroy_user_session_path

    when /the admin page/
      pages_admin_path
      
    when /the request account page/
      new_user_registration_path
      
    when /the access requests page/
      access_requests_users_path
      
    when /the list users page/
      users_path

    when /the list people page/
      people_path

    when /the list herbaria page/
      herbaria_path

    when /the create person page/
      new_person_path    

    when /the create herbarium page/
      new_herbarium_path

    when /the person page for "(.*)"$/
      person_path(Person.find_by_last_name($1))

    when /the edit person page for "(.*)"$/
      edit_person_path(Person.find_by_last_name($1))

    when /the edit herbarium page for "(.*)"$/
      edit_herbarium_path(Herbarium.find_by_code($1))

    when /^the user details page for (.*)$/
      user_path(User.where(:email => $1).first)
      
    when /^the edit profile page for (.*)$/
      edit_profile_user_path(User.where(:email => $1).first)

    when /^the specimens needing review page$/
      needing_review_specimens_path
        
    when /^the species page for "(.*)"$/
      species_path(Species.where(:name => $1).first)

    when /^the edit species page for "(.*)"$/
      edit_species_path(Species.where(:name => $1).first)

    when /^the create species page$/
      new_species_path

    when /^the list species page$/
      species_index_path

    when /the Advanced Search page/
      advanced_search_specimens_path


    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
