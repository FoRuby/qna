class SearchController < ApplicationController
  def search
    authorize! :search, User

    @search_results =
      SearchService.call(params[:search_string], params[:search_scope])

    redirect_to questions_path, alert: 'Invalid query' unless @search_results
  end
end
