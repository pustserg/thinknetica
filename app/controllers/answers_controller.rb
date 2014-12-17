class AnswersController < ApplicationController

  before_action :authenticate_user!, except: :show
  
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, except: [:new, :create]
  before_action :check_author, only: [:destroy, :edit]

  def show
  end

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  def edit
    @question = @answer.question
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer.question
    else
      render :edit
    end
  end

  def destroy
    @question = @answer.question
    if @answer.destroy
      redirect_to @question
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def check_author
    if current_user != @answer.user
      render json: { error: "fufufu" }, status: 403
    end
  end

end
