class UsersController < ApplicationController

  before_action :set_user

  def show
    @questions = @user.questions
    @answers = @user.answers
    @comments = @user.comments
  end

  def edit
  end

  def update
    existed_user = User.find_by(email: params[:user][:email])
    if existed_user
      existed_user.create_authorization(@user.authorizations.first)
      @user.destroy
      sign_in_and_redirect existed_user, event: :authentication
    else
      @user.update!(user_params)
      sign_in_and_redirect @user, event: :authentication
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end

end
