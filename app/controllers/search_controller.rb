class SearchController < ApplicationController
  skip_authorization_check

  def search
    query = Sunspot.search(Question, Answer) do
      keywords params[:search] do
        highlight :title
      end
    end

    @objects = query.results
    render 'search/search_result'
  end
end