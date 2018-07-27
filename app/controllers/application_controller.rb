class ApplicationController < ActionController::Base
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action do record_activity('') end	
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  def record_activity(note)

  @log = Log.new
  @log.user = current_user.username
  @log.note = note
  @log.browser = request.env['HTTP_USER_AGENT']
  @log.ip_address = request.env['REMOTE_ADDR']
  @log.controller = controller_name
  @log.action = action_name
  @log.params = params.inspect
  @log.save
end

  protected

def configure_permitted_parameters
  # # devise 4.3 .for method replaced by .permit
  devise_parameter_sanitizer.permit(:sign_in, keys: [:username, :email])
  # #devise_parameter_sanitizer.permit(:sign_in) << :username


  # added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
  #   devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
  #   devise_parameter_sanitizer.permit :account_update, keys: added_attrs
end
end
