module PolyteneApiHelpers
  PRIVATE_TOKEN_PARAM = :private_token
  PRIVATE_TOKEN_HEADER = "HTTP_PRIVATE_TOKEN"

  def current_runner
    @current_runner ||= Runner.where(:private_token => (params[PRIVATE_TOKEN_PARAM] || env[PRIVATE_TOKEN_HEADER]), :is_active => true).first
  end

  def current_user
    @current_user ||= User.authenticate(params[:login], params[:password])
  end

  def authenticate_runner!
    unauthorized! unless current_runner
  end

  def update_public_key_for_runner(public_ssh_key)
    current_runner.update_column(:public_ssh_key, public_ssh_key) if current_runner
  end

  def update_last_seen_for_runner
    current_runner.update_column(:last_seen, Time.now) if current_runner
  end

  def authenticate_user!
    unauthorized! unless current_user
  end

  def required_attributes!(keys)
    keys.each do |key|
      bad_request!(key) unless params[key].present?
    end
  end

  def forbidden!
    render_api_error!('403 Forbidden', 403)
  end

  def bad_request!(attribute)
    message = ["400 (Bad request)"]
    message << "\"" + attribute.to_s + "\" not given"
    render_api_error!(message.join(' '), 400)
  end

  def not_found!(resource = nil)
    message = ["404"]
    message << resource if resource
    message << "Not Found"
    render_api_error!(message.join(' '), 404)
  end

  def unauthorized!
    render_api_error!('401 Unauthorized', 401)
  end

  def not_allowed!
    render_api_error!('Method Not Allowed', 405)
  end

  def render_api_error!(message, status)
    error!({'message' => message}, status)
  end
end
