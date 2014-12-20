require "rails_admin_project_branch_builds/engine"

module RailsAdminProjectBranchBuilds
end

require 'rails_admin/config/actions'

module RailsAdmin
  module Config
    module Actions
      class ProjectBranchBuilds < Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :only do
          ['ProjectBranch']
        end

        register_instance_option :member? do
          true
        end

        register_instance_option :visible? do
          authorized?
        end

        register_instance_option :link_icon do
          'icon-tasks'
        end

        register_instance_option :object_level do
          true
        end

        register_instance_option :http_methods do
          [:get]
        end

        register_instance_option :controller do
          proc do
            @associated_abstract_model = RailsAdmin.config('Build').abstract_model
            @associated_model_config = @associated_abstract_model.try(:config)

            project_branch = @object
            additional_scope = Proc.new { where(:project_branch_id => project_branch.id) }

            @objects = list_entries(@associated_model_config, :index, additional_scope, !(params[:associated_collection] || params[:all] || params[:bulk_ids]))
            @objects = @objects.send(@associated_model_config.list.scopes.first) if params[:scope].blank? && !@associated_model_config.list.scopes.first.nil?
            @objects = @objects.send(params[:scope].to_sym) if !params[:scope].blank? && @associated_model_config.list.scopes.collect(&:to_s).include?(params[:scope])

            render action: @action.template_name
          end
        end
      end
    end
  end
end
