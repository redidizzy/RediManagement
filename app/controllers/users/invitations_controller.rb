class Users::InvitationsController < Devise::InvitationsController
  private
    # This is called when creating invitation.
    # It should return an instance of resource class.
    def invite_resource
      # Add tenant to user
      super do |user| 
        user.tenant = ActsAsTenant.current_tenant 
        user.skip_confirmation!
      end
    end

    # This is called when accepting invitation.
    # It should return an instance of resource class.
    # def accept_resource
    #   resource = resource_class.accept_invitation!(update_resource_params)
    #   # Report accepting invitation to analytics
    #   Analytics.report('invite.accept', resource.id)
    #   resource
    # end
end