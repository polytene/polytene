require "rails_admin_build_project_branch/engine"

module RailsAdminBuildProjectBranch
end

require 'rails_admin/config/actions'

module RailsAdmin
  module Config
    module Actions
      class BuildProjectBranch < Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :only do
          ['Build']
        end

        register_instance_option :http_methods do
          [:get]
        end

        register_instance_option :controller do
          proc do
            @associated_abstract_model = RailsAdmin.config('ProjectBranch').abstract_model
            @associated_model_config = @associated_abstract_model.try(:config)
            @associated_object = @object.project_branch
          end
        end

        register_instance_option :link_icon do
          'icon-comment'
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

