# -*- encoding : utf-8 -*-
class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show] 
  
  load_resource
  
  before_action :build_answer, only: :show

  include VoteableController

  authorize_resource

  def index
    respond_with(@questions = filter)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with (@question = current_user.questions.create(question_params))
  end

  def edit
    respond_with(@question)
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy)
  end

  def add_to_favs
    @question.add_subscribers(current_user)
    head :ok
  end

  private

  def resource
    @question
  end

  def set_resource
     @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :tag_list, attachments_attributes: [:file])
  end

  def build_answer
    @answer = @question.answers.build  
  end

  def filter
    return Tag.find_by(name: params[:tag_name]).questions if params[:tag_name]
    return (Question.search { fulltext params[:search] }).results if params[:search]
    return Question.answered(params[:answered]) if params[:answered]
    Question.all
  end

end
