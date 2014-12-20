require "rails_admin_build_deployment_status/engine"

module RailsAdminBuildDeploymentStatus
end

require 'rails_admin/config/actions'

module RailsAdmin
  module Config
    module Actions
      class BuildDeploymentStatus < Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :member? do
          true
        end

        register_instance_option :http_methods do
          [:get]
        end

        register_instance_option :object_level do
          true
        end

        register_instance_option :visible? do
          false
        end

        register_instance_option :controller do
          proc do
            respond_to do |format|
              format.json {
                render json: object.to_json(methods: [:stderr_deployment_trace, :stdout_deployment_trace])
              }
            end
          end
        end
      end
    end
  end
end

