class Ability
  include CanCan::Ability

  def initialize(user)
    # alias edit_replicates to update_replicates so that they don't have to be declared separately
    alias_action :edit_replicates, :to => :update_replicates

    # alias edit_specimen_images to update_specimen_images so that they don't have to be declared separately
    alias_action :edit_specimen_images, :to => :update_specimen_images

    # alias edit_profile to update_profile so that they don't have to be declared separately
    alias_action :edit_profile, :to => :update_profile
    alias_action :edit_approval, :to => :approve

    # alias activate and deactivate to "activate_deactivate" so its just a single permission
    alias_action :deactivate, :to => :activate_deactivate
    alias_action :activate, :to => :activate_deactivate

    # alias access_requests to view_access_requests so the permission name is more meaningful
    alias_action :access_requests, :to => :view_access_requests

    # alias reject_as_spam to reject so they are considered the same
    alias_action :reject_as_spam, :to => :reject

    # alias labels to read so its considered to be a read operation
    alias_action :labels, :to => :read

    # alias needing_review to view_needing_review so the permission name is more meaningful
    alias_action :needing_review, :to => :view_needing_review

    # alias search to be the same as read
    alias_action :latest, :to => :read
    alias_action :search, :to => :read
    alias_action :search_results, :to => :read
    alias_action :search_results_print_labels, :to => :read
    alias_action :advanced_search, :to => :read
    alias_action :advanced_search_results, :to => :read
    alias_action :advanced_search_form, :to => :read

    alias_action :autocomplete_herbarium_name, :to => :read

    return unless user.profile

    can_view_deaccessioned = user.profile.has_permission("Specimen", "view_deaccessioned")

    user.profile.permissions.each do |permission|
      action = permission.action.to_sym

      if permission.entity == 'Specimen'
        # handle specimens differently: we want to add a special condition depending on whether or not they can see de-accessioned specimens
        handle_specimen_permission(can_view_deaccessioned, action)
      else
        can action, permission.entity.constantize
      end
      
    end
  end
  
  private
  
  def handle_specimen_permission(can_view_deaccessioned, action)
    if can_view_deaccessioned
       can action, Specimen
     else
       can action, Specimen, :status => [nil, "", "DeAccReq"]
     end
   end
end
