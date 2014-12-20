require "rails_admin_bulk_runners_registering/engine"

module RailsAdminBulkRunnersRegistering
end

require 'rails_admin/config/actions'

module RailsAdmin
  module Config
    module Actions
      class BulkRunnersRegistering < Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :http_methods do
          [:post, :put]
        end

        register_instance_option :object_level do
          true
        end

        register_instance_option :bulkable? do
          true
        end

        register_instance_option :visible? do
          authorized? && bindings[:abstract_model].to_s == 'Project'
        end

        register_instance_option :pjax? do
          false
        end

        register_instance_option :controller do
          proc do
            @runners_abstract_model = RailsAdmin.config('Runner').abstract_model

            if request.post?
              @objects = list_entries(@model_config, :bulk_runners_registering)
              @runners = @authorization_adapter.query(:index, @runners_abstract_model)

              render @action.template_name
            elsif request.put?
              @runner = Runner.find(params['runner_id'])
              @authorization_adapter.authorize(:show, @runners_abstract_model, @runner)

              @objects = list_entries(@model_config, :bulk_runners_registering)
              @updated_objects = []

              @objects.each do |obj|
                @updated_objects << obj if obj.update({:runner_id => @runner.id})
              end

              @not_updated_objects = @objects-@updated_objects

              RegisterDeployKeyWorker.perform_async(@updated_objects.map(&:id)) if params['register_deploy_key'].to_boolean

              @updated_objects.each do |object|
                @auditing_adapter && @auditing_adapter.update_object(object, @abstract_model, _current_user, object.changes)
              end

              flash[:success] = t('admin.flash.successful', name: pluralize(@updated_objects.count, @model_config.label), action: t('admin.actions.bulk_runners_registering.done')) unless @updated_objects.empty?
              flash[:error] = t('admin.flash.error', name: pluralize((@objects.count-@updated_objects.count), @model_config.label), action: t('admin.actions.bulk_runners_registering.done')) unless @not_updated_objects.empty?

              redirect_to back_or_index
            end
          end
        end

        register_instance_option :link_icon do
          'icon-ok-sign'
        end

        register_instance_option :collection do
          true
        end

      end
    end
  end
end

