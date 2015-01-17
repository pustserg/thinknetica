# -*- encoding : utf-8 -*-
class CommentsController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_commentable, only: [:new, :create]
  before_action :set_resource, only: [:edit, :update, :destroy, :vote_up, :vote_down]
  before_action :check_author, only: [:edit, :update, :destroy]
  before_action :set_question, only: :destroy

  include VoteableController

  def new
    respond_with(@resource = @commentable.comments.new)
  end

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)))
  end

  def edit
    respond_with @resource
  end

  def update
    @resource.update(comment_params)
    respond_with @resource
  end

  def destroy
    @question = set_question
    respond_with(@resource.destroy, location: question_path(@question))
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

  def set_question
    if @commentable.class == Answer
      @question = @resource.commentable.question 
    else
      @question = @resource.commentable
    end
    @question
  end

  def set_resource
    @resource = Comment.find(params[:id])
  end

end
