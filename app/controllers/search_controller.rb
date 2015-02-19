class SearchController < ApplicationController
  skip_authorization_check

  def search
    @questions = Question.search(params[:search])
    render 'search/search_result'
  end
end