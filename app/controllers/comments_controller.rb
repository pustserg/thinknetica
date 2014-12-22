class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question

  def new
    @comment = Comment.new
  end

  def create
    @comment = @question.comments.create(comment_params.merge(user: current_user))
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

end
