# -*- encoding : utf-8 -*-
class CommentsController < ApplicationController
  before_action :authenticate_user!, except: :show
  load_resource
  before_action :set_commentable, only: [:new, :create]

  include VoteableController

  authorize_resource

  def new
    respond_with(@comment = @commentable.comments.new)
  end

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)))
  end

  def edit
    respond_with @comment
  end

  def update
    @comment.update(comment_params)
    respond_with @comment
  end

  def destroy
    @question = @comment.question
    respond_with(@comment.destroy, location: question_path(@question))
  end

  private

  def resource
    @comment
  end

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
