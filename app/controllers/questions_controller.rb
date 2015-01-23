# -*- encoding : utf-8 -*-
class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show] 
  
  before_action :set_resource, only: [:show, :edit, :update, :destroy, :vote_up, :vote_down]
  # before_action :check_author, only: [:destroy, :edit, :update]

  before_action :build_answer, only: :show

  include VoteableController

  authorize_resource

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
    respond_with(@resource)
  end

  def update
    @resource.update(question_params)
    respond_with(@resource)
  end

  def destroy
    respond_with(@resource.destroy)
  end

  private

  def set_resource
     @resource = @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :tag_list, attachments_attributes: [:file])
  end

  def build_answer
    @answer = @resource.answers.build  
  end

  def filter
    return Tag.find_by(name: params[:tag_name]).questions if params[:tag_name]
    return (Question.search { fulltext params[:search] }).results if params[:search]
    return Question.answered(params[:answered]) if params[:answered]
    Question.all
  end

end
