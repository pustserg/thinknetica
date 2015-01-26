class Api::V1::QuestionsController < Api::V1::ApiController

  load_resource

  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    respond_with @question
  end

end