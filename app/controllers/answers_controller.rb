# -*- encoding : utf-8 -*-
class AnswersController < ApplicationController

  before_action :authenticate_user!, except: :show
  
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, except: [:new, :create]
  before_action :check_author, only: [:destroy, :edit, :update]
  before_action :check_question_author, only: :make_best
  before_action :check_for_voting, only: [:vote_down, :vote_up]

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
    redirect_to @question if @answer.destroy
    # respond_with @answer.destroy, location: -> { @question }
  end

  def make_best
    @answer.make_best
    redirect_to :back
  end

  def vote_up
    @answer.vote_up(current_user)
    redirect_to @answer.question
  end

  def vote_down
    @answer.vote_down(current_user)
    redirect_to @answer.question
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def check_author
    if current_user != @answer.user
      render json: { error: "fufufu" }, status: 403
    end
  end

  def check_question_author
    if current_user != @answer.question.user
      render json: { error: "fufufu" }, status: 403
    end
  end

  def check_for_voting
 
    render json: { error: 'fufufu' }, status: 403 if current_user == @answer.user
    
    @answer.votes.each do |vote|
      redirect_to @answer.question and return if vote.user == current_user
    end
  end

end
