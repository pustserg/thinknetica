class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable

  def new
    @comment = Comment.new
  end

  def create
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    @commentable = if params[:question_id].present?
                    Question.find(params[:question_id])
                  elsif params[:answer_id].present?
                    Answer.find(params[:answer_id])
                  end
                    
  end

end
