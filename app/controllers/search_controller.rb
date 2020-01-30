class SearchController < ApplicationController
  def search
    authorize! :search, User

    @search_results = SearchService.call(search_params)
  end

  def search_params
    params.require(:search).permit(:query, :scope).to_h.symbolize_keys
  end
end
