require "rails_admin_invite/engine"

module RailsAdminInvite
end

require 'rails_admin/config/actions'

module RailsAdmin
  module Config
    module Actions
      class Invite < Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :link_icon do
          'icon-envelope'
        end

        register_instance_option :http_methods do
          [:get, :post]
        end

        register_instance_option :root? do
          true
        end  

        register_instance_option :controller do
          proc do
            if request.post?
              if (not params[:email].blank?) && params[:email].is_email?
                User.invite!(:email => params[:email])
                notice = t('admin.flash.successful', name: nil, action: t("admin.actions.invite.done"))
                redirect_to dashboard_path, flash: {success: notice}
              else
                @error = t('polytene.provide_valid_email')
                render action: @action.template_name
              end
            else
              render action: @action.template_name
            end
          end
        end
      end
    end
  end
end

