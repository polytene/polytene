require "rails_admin_project_builds/engine"

module RailsAdminProjectBuilds
end

require 'rails_admin/config/actions'

module RailsAdmin
  module Config
    module Actions
      class ProjectBuilds < Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :only do
          ['Project']
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
      
            project = @object
            additional_scope = Proc.new { where(:project_id => project.id) }

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

