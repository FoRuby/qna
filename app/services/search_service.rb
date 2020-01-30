class SearchService
  SCOPES = %w[Question Answer Comment User].freeze

  def self.call(params)
    query = ThinkingSphinx::Query.escape(params[:query])
    return ThinkingSphinx.search(query) if SCOPES.exclude?(params[:scope])

    ThinkingSphinx.search(query, classes: [params[:scope].constantize])
  end
end
