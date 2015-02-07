class SearchController < ApplicationController
  skip_authorization_check

  def search
    search_classes = []
    search_classes << Question if params[:questions_only]
    search_classes << Answer if params[:answers_only]
    search_classes << Comment if params[:comments_only]
    if search_classes.empty?
      search_classes = [Question, Answer, Comment]
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