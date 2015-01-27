class Api::V1::AnswersController < Api::V1::ApiController

  load_resource
  before_action :set_question, only: :create

  def show
    respond_with @answer
  end

  def create
    @answer = current_resource_owner.answers.create(answer_params.merge(question: @question))
    respond_with @answer
  end

  private
  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

end