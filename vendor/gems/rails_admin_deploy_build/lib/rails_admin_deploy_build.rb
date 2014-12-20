require "rails_admin_deploy_build/engine"

module RailsAdminDeployBuild
end

require 'rails_admin/config/actions'

module RailsAdmin
  module Config
    module Actions
      class DeployBuild < Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :only do
          ['Build']
        end

        register_instance_option :http_methods do
          [:post, :get]
        end

        register_instance_option :controller do
          proc do
            if request.post?

              case params[:deploy_action]
              when "deploy" then
                if object.can_be_deployed?
                  object.initialize_for_deployment(current_user.id)
                else
                  flash[:notice] = t('polytene.build_cannot_be_deployed')
                end
              when "redeploy" then
                if object.can_be_deployed_again? && object.deployment_can_be_cleared?
                  object.clear_deployment
                  object.initialize_for_deployment(current_user.id)
                else
                  flash[:notice] = t('polytene.build_cannot_be_redeployed')
                end
              when "abort" then
                if object.deployment_can_be_aborted?
                  object.abort_deployment
                else
                  flash[:notice] = t('polytene.deployment_cannot_be_aborted')
                end
              end

              redirect_to deploy_build_url
            end
          end
        end

        register_instance_option :link_icon do
          'icon-cog'
        end

        register_instance_option :member? do
          true
        end

        register_instance_option :visible? do
          authorized?
        end

        register_instance_option :object_level do
          true
        end
      end
    end
  end
end

