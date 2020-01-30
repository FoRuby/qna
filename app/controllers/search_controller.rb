class SearchController < ApplicationController
  def search
    authorize! :search, User

    @search_results = SearchService.call(params[:search])
  end
end
