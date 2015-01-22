require "application_responder"

# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html, :js

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :set_tags

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  check_authorization unless: :devise_controller?

  protected

  def check_author
    if current_user != @resource.user
      render json: { error: "fufufu" }, status: 403
    end
  end

  def set_tags
    @tag_cloud = Tag.all
  end
end
