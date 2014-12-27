class UsersController < ApplicationController

  before_action :set_user

  def show
    @questions = @user.questions
    @answers = @user.answers
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end
