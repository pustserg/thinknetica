# -*- encoding : utf-8 -*-
class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show] 
  
  before_action :set_resource, only: [:show, :edit, :update, :destroy, :vote_up, :vote_down]
  before_action :check_author, only: [:destroy, :edit, :update]
  before_action :check_for_voting, only: [:vote_down, :vote_up]

  def index
<<<<<<< HEAD
    # @tags = Question.tag_counts_on(:tags)
    if params[:tag]
      @questions = Question.tagged_with(params[:tag])
=======
    if params[:tag_name]
      @questions = Tag.find_by(name: params[:tag_name]).questions
    elsif params[:search]
      @query = Question.search do
        fulltext params[:search]
      end
      @questions = @query.results
    elsif params[:filter]
      if params[:filter] == 'answered'
        @questions = Question.answered
      elsif params[:filter] == 'not_answered'
        @questions = Question.not_answered
      end   
>>>>>>> bfbda3bfdda277e18e6025965f219bf4c19bae6e
    else
      @questions = Question.all
    end
  end

  def show
    @answer = @resource.answers.build
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
    # @question.tag_list
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

  def vote_up
    @resource.vote_up(current_user)
    redirect_to @resource
  end

  def vote_down
    @resource.vote_down(current_user)
    redirect_to @resource
  end

  private

  def set_resource
    @resource = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :tag_list, attachments_attributes: [:file])
  end

  def check_for_voting
 
    render json: { error: 'fufufu' }, status: 403 if current_user == @resource.user
    
    @resource.votes.each do |vote|
      if vote.user == current_user
        redirect_to @resource and return
      end
    end
  end

end
