require "rails_admin_import_projects/engine"

module RailsAdminImportProjects
end

require 'rails_admin/config/actions'

module RailsAdmin
  module Config
    module Actions
      class ImportProjects < Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :link_icon do
          'icon-download-alt'
        end

        register_instance_option :http_methods do
          [:get, :post]
        end

        register_instance_option :controller do
          proc do
            if request.post?
              project = current_user.has_imported_gitlab_ci_project?(params[:gitlab_ci_project_id])

              if project
                authorize! :destroy, project
                project.destroy
              else
                Project.import_gitlab_ci_project(params[:gitlab_ci_project_id], current_user.id)
              end

              redirect_to import_projects_url
            else
              @gitlab_ci_projects = current_user.avaiable_gitlab_ci_projects if current_user.blank_required_profile_attributes.size == 0
            end
          end
        end

        register_instance_option :visible? do
          authorized? && bindings[:abstract_model].to_s == 'Project'
        end

        register_instance_option :collection? do
          true
        end

        register_instance_option :object_level do
          true
        end
      end
    end
  end
end

