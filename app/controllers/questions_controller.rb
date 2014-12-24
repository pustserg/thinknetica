class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show] 
  
  before_action :set_resource, only: [:show, :edit, :update, :destroy]
  before_action :check_author, only: [:destroy, :edit, :update]

  def index
    @questions = Question.all
  end

  def show
    @answer = @resource.answers.build
  end

  def new
    @question = Question.new
    @question.attachments.build
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
    @question = @resource
  end

  def update
    @resource.update(question_params)
  end

  def destroy
    @resource.destroy
    redirect_to questions_path
  end

  private

  def set_resource
    @resource = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

  # def check_author
  #   if current_user != @question.user
  #     render json: { error: 'fufufu' }, status: 403
  #   end
  # end

end
