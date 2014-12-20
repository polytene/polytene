require "rails_admin_password_edit/engine"

module RailsAdminPasswordEdit
end

require 'rails_admin/config/actions'

module RailsAdmin
  module Config
    module Actions
      class PasswordEdit < Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :member? do
          true
        end

        register_instance_option :link_icon do
          'icon-user'
        end

        register_instance_option :only do
          [Profile]
        end

        register_instance_option :controller do
          proc do
            if request.put?
              @edited_object = @object.user
              @edited_object.password = params[:password]
              @edited_object.password_confirmation = params[:password_confirmation]

              if @edited_object.save
                sign_in @edited_object, :bypass => true
                notice = t('admin.flash.successful', name: nil, action: t("admin.actions.password_edit.done"))
                redirect_to dashboard_path, flash: {success: notice}
              else
                render action: @action.template_name
              end
            else
              @edited_abstract_model = RailsAdmin.config('User').abstract_model
              @edited_model_config = @edited_abstract_model.try(:config)
              @edited_object = @object.user

              render action: @action.template_name
            end
          end
        end

        register_instance_option :http_methods do
          [:get, :put]
        end
      end
    end
  end
end

