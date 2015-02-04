class UsersController < ApplicationController

  before_action :set_user, except: :finish_signup

  authorize_resource

  def show
    @user_votes = @user.user_votes.values.flatten
    respond_with(@user)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end

end
