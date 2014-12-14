class AnswersController < ApplicationController
  before_action :set_question
  before_action :set_answer, only: [:show, :edit, :destroy, :update]
  before_action :authenticate_user!, except: :show

  def show
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @answer.update(answer_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if @answer.destroy
      redirect_to @question
    end
  end

  private

  def set_answer
    @answer = @question.answers.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end

end
