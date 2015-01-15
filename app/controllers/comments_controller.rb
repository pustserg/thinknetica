# -*- encoding : utf-8 -*-
class CommentsController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_commentable, only: [:new, :create]
  before_action :set_resource, only: [:edit, :update, :destroy, :vote_up, :vote_down, :show]
  before_action :check_author, only: [:edit, :update, :destroy]
  before_action :check_for_voting, only: [:vote_up, :vote_down]

  def show
    redirect_to @resource.commentable
  end

  def new
    respond_with(@resource = @commentable.comments.new)
  end

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)))
  end

  def edit
    @commentable = @resource.commentable
    respond_with @resource
  end

  def update
    @commentable = @resource.commentable
    @resource.update(comment_params)
    respond_with @resource
  end

  def destroy
    @commentable = @resource.commentable
    if @resource.destroy
      redirect_to @commentable
    end
  end

  def vote_up
    @resource.vote_up(current_user)
    redirect_to @resource.commentable
  end

  def vote_down
    @resource.vote_down(current_user)
    redirect_to @resource.commentable
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

  def check_for_voting
 
    render json: { error: 'fufufu' }, status: 403 if current_user == @resource.user
    
    @resource.votes.each do |vote|
      if vote.user == current_user
        redirect_to @resource and return
      end
    end
  end

end
