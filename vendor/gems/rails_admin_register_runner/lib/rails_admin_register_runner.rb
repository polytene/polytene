require "rails_admin_register_runner/engine"

module RailsAdminRegisterRunner
end

require 'rails_admin/config/actions'

module RailsAdmin
  module Config
    module Actions
      class RegisterRunner < Base
        RailsAdmin::Config::Actions.register(self)
        
        register_instance_option :only do
          [Project]
        end

        register_instance_option :except do
          []
        end

        # http://getbootstrap.com/2.3.2/base-css.html#icons
        register_instance_option :link_icon do
          'icon-ok-sign'
        end

        # Should the action be visible
        register_instance_option :visible? do
          authorized?
        end

        # Is the action acting on the root level (Example: /admin/contact)
        register_instance_option :root? do
          false
        end

        # Is the action on a model scope (Example: /admin/team/export)
        register_instance_option :collection? do
          false
        end

        # Is the action on an object scope (Example: /admin/team/1/edit)
        register_instance_option :member? do
          true
        end

        # Render via pjax?
        register_instance_option :pjax? do
          true
        end

        # This block is evaluated in the context of the controller when action is called
        # You can access:
        # - @objects if you're on a model scope
        # - @abstract_model & @model_config if you're on a model or object scope
        # - @object if you're on an object scope
        register_instance_option :controller do
          proc do
            @runners_abstract_model = RailsAdmin.config('Runner').abstract_model
            @runners = @authorization_adapter.query(:index, @runners_abstract_model)
            
            if request.put?
              @object.runner_id = params[:runner_id]
              if @object.save
                RegisterDeployKeyWorker.perform_async([@object.id]) if params['register_deploy_key'].to_boolean

                notice = t('admin.flash.successful', name: nil, action: t("admin.actions.register_runner.done"))
                redirect_to back_or_index, flash: {success: notice}
              else
                @errors = @object.errors
                render action: @action.template_name
              end
            elsif request.get?
              render action: @action.template_name
            end
          end
        end

        # Model scoped actions only. You will need to handle params[:bulk_ids] in controller
        register_instance_option :bulkable? do
          false
        end

        # View partial name (called in default :controller block)
        register_instance_option :template_name do
          key.to_sym
        end

        # For Cancan and the like
        register_instance_option :authorization_key do
          key.to_sym
        end

        # List of methods allowed. Note that you are responsible for correctly handling them in :controller block
        register_instance_option :http_methods do
          [:get, :put]
        end

        # Url fragment
        register_instance_option :route_fragment do
          custom_key.to_s
        end

        # Controller action name
        register_instance_option :action_name do
          custom_key.to_sym
        end

        # I18n key
        register_instance_option :i18n_key do
          key
        end

        # User should override only custom_key (action name and route fragment change, allows for duplicate actions)
        register_instance_option :custom_key do
          key
        end

        # Breadcrumb parent
        register_instance_option :breadcrumb_parent do
          case
          when root?
            [:dashboard]
          when collection?
            [:index, bindings[:abstract_model]]
          when member?
            [:show, bindings[:abstract_model], bindings[:object]]
          end
        end
      end
    end
  end
end

