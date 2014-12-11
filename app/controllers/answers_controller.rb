class AnswersController < ApplicationController
  before_action :set_answer

  def show
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

end
