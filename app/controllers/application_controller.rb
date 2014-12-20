class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout :layout_by_resource

  before_filter :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    if request.xhr?
      render :json => {:message => 'Not authorized'}
    else
      if user_signed_in? && respond_to?('dashboard_path')
        redirect_to dashboard_path, :alert => exception.message
      else
        redirect_to main_app.root_path, :alert => exception.message
      end
    end
  end

  def after_sign_in_path_for(resource)
    "/dashboard"
  end

  private

  def authenticate_inviter!
    raise CanCan::AccessDenied.new('Use link in main navigation to invite another user')
  end

  def set_locale
    I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
  end

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

end
