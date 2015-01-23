# -*- encoding : utf-8 -*-
class AnswersController < ApplicationController

  before_action :authenticate_user!, except: :show
  
  load_resource

  before_action :set_question, only: [:new, :create]
  before_action :check_question_author, only: :make_best
  
  include VoteableController

  authorize_resource
  
  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def edit
    @question = @answer.question
    respond_with @answer
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    @question = @answer.question
    respond_with(@answer.destroy, location: question_path(@question))
  end

  def make_best
    @answer.make_best
    respond_with(@answer, location: @answer.question)
  end

  private

  def resource
    @answer
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def check_question_author
    if current_user != @answer.question.user
      render json: { error: "fufufu" }, status: 403
    end
  end

end
