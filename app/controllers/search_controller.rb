class SearchController < ApplicationController
  skip_authorization_check

  def search
    if params[:questions_only]
      search_classes = Question
    elsif params[:answers_only]
      search_classes = Answer
    elsif params[:comments_only]
      search_classes = Comment
    else
      search_classes = Question, Answer, Comment
    end

    query = Sunspot.search(search_classes) do
      keywords params[:search] do
        # highlight :title
      end
    end

    @objects = query.results
    render 'search/search_result'
  end
end