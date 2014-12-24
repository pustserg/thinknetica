class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: [:new, :create]
  before_action :set_resource, only: [:edit, :update, :destroy]
  before_action :check_author, only: [:edit, :update, :destroy]

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
    @commentable = @resource.commentable
    @resource.update(comment_params)
  end

  def destroy
    @commentable = @resource.commentable
    if @resource.destroy
      redirect_to @commentable
    end
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
