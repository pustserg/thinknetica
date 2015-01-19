class UsersController < ApplicationController

  before_action :set_user

  authorize_resource

  def show
    @questions = @user.questions
    @answers = @user.answers
    @comments = @user.comments
  end

  def finish_signup
    if @user.email !~ /.temp/
      @user.update(email: user.email)
      @user.save!
      sign_in_and_redirect @user, event: :authentication
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end
