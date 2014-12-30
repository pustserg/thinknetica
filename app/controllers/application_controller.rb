# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :set_tags

  protected

  def check_author
    if current_user != @resource.user
      render json: { error: "fufufu" }, status: 403
    end
  end

  def set_tags
    @tags = Question.tag_counts_on(:tags) || []
  end
end
