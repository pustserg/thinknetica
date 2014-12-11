class AnswersController < ApplicationController
  before_action :set_answer, only: :show

  def show
  end

  def new
    @answer = Answer.new
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

end
