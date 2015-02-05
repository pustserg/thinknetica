class SearchController < ApplicationController
  skip_authorization_check

  def search
    query = Sunspot.search(Question, Answer) { keywords params[:search] }
    @objects = query.results
    @questions = @objects
    render 'questions/index'
  end
end