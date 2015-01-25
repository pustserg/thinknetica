class Api::V1::QuestionsController < Api::V1::ApiController

  def index
    @questions = Question.all
    respond_with @questions
  end

end