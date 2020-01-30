class SearchController < ApplicationController
  def search
    authorize! :search, User

    @search_results =
      SearchService.call(params[:search_string], params[:search_scope])
  end
end
