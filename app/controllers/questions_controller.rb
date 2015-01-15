# -*- encoding : utf-8 -*-
class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show] 
  
  before_action :set_resource, only: [:show, :edit, :update, :destroy, :vote_up, :vote_down]
  before_action :check_author, only: [:destroy, :edit, :update]
  before_action :check_for_voting, only: [:vote_down, :vote_up]

  before_action :build_answer, only: :show

  def index
    respond_with(@questions = filter)
  end

  def show
    respond_with @resource
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with (@question = current_user.questions.create(question_params))
  end

  def edit
    @question = @resource
    respond_with @question
  end

  def update
    @resource.update(question_params)
    respond_with(@resource)
  end

  def destroy
    respond_with(@resource.destroy)
  end

  def vote_up
    @resource.vote_up(current_user)
    redirect_to @resource
  end

  def vote_down
    @resource.vote_down(current_user)
    redirect_to @resource
  end

  private

  def set_resource
    @resource = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :tag_list, attachments_attributes: [:file])
  end

  def build_answer
    @answer = @resource.answers.build  
  end

  def filter
    if params[:tag_name]
      Tag.find_by(name: params[:tag_name]).questions
    elsif params[:search]
      @query = Question.search do
        fulltext params[:search]
      end
      @query.results
    elsif params[:filter]
      if params[:filter] == 'answered'
        Question.answered
      elsif params[:filter] == 'not_answered'
        Question.not_answered
      end   
    else
      Question.all
    end
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
