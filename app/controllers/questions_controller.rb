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
    respond_with(@question = @resource)
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
      (Question.search { fulltext params[:search] }).results
    elsif params[:answered]
      Question.answered(params[:answered])
    else
      Question.all
    end
  end

  # def filter
  #   Tag.find_by(name: params[:tag_name]).questions if params[:tag_name]
  #   (Question.search { fulltext params[:search] }).results if params[:search]
  #   Question.answered(params[:answered]) if params[:answered]
  #   false
  # end

end
