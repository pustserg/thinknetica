class RegistrationsController < Devise::RegistrationsController
  def new
    self.resource = User.new(sign_in_params)
    if session[:provider] && session[:uid]
      render 'oauth_registration'
    else
      super
    end
  end

  def create
    build_resource(sign_up_params)
    auth = Authorization.new(uid: session[:uid], provider: session[:provider])
    resource.password = session[:password]

    if session[:provider] && session[:uid]
      @existed_user = User.find_by(email: resource.email)
      if @existed_user
        @existed_user.create_authorization(auth)
        reset_session
        sign_in @existed_user
        respond_with @existed_user, location: after_sign_up_path_for(resource)
      else
        resource.save
        resource.create_authorization(auth)
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      end
    else
      super
    end
  end

  def update
    super
  end

  protected

  def sign_in_params
    devise_parameter_sanitizer.sanitize(:sign_in)
  end
end