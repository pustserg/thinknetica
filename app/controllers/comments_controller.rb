class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable
  before_action :set_resource, only: [:edit, :update]
  before_action :check_author, only: [:destroy, :edit, :update]

  def new
    @resource = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
  end

  def edit
    @commentable = @resource.commentable
  end

  def update
    @resource.update(comment_params)
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

  def set_resource
    @resource = Comment.find(params[:id])
  end

end
