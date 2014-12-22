class CommentsController < ApplicationController
  before_action :authenticate_user!, only: :new
  before_action :set_question, only: :new

  def new
    @comment = Comment.new
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

end
