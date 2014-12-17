class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show] 
  
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :check_author, only: [:destroy, :edit, :update]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def check_author
    if current_user != @question.user
      render json: { error: 'fufufu' }, status: 403
    end
  end

end
