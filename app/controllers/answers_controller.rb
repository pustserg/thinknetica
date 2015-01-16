# -*- encoding : utf-8 -*-
class AnswersController < ApplicationController

  before_action :authenticate_user!, except: :show
  
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, except: [:new, :create]
  before_action :check_author, only: [:destroy, :edit, :update]
  before_action :check_question_author, only: :make_best
  
  include VoteableController


  def create
    respond_with(@resource = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def edit
    @question = @resource.question
    respond_with @resource
  end

  def update
    @resource.update(answer_params)
    respond_with @resource
  end

  def destroy
    @question = @resource.question
    redirect_to @question if @resource.destroy
    # respond_with @resource.destroy, location: -> { @question }
  end

  def make_best
    @resource.make_best
    redirect_to :back
  end

  private

  def set_answer
    @resource = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def check_question_author
    if current_user != @resource.question.user
      render json: { error: "fufufu" }, status: 403
    end
  end

end
