class SearchService
  SCOPES = %w[Question Answer Comment User All].freeze

  def self.call(search_string, search_scope)
    return if search_string.empty? || SCOPES.exclude?(search_scope)

    query = ThinkingSphinx::Query.escape(search_string)
    return ThinkingSphinx.search(query) if search_scope == 'All'

    ThinkingSphinx.search(query, classes: [search_scope.constantize])
  end
end
