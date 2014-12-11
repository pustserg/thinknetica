class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :destroy, :update]

  def show
  end

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(answer_params)
    if @answer.save
      redirect_to @answer.question
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer.question
    else
      render :edit
    end
  end

  def destroy
    question = @answer.question
    if @answer.destroy
      redirect_to question
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end

end
