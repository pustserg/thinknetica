class Api::V1::AnswersController < Api::V1::ApiController

  load_resource

  def show
    respond_with @answer
  end

end