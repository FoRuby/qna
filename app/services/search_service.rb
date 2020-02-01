class SearchService
  SCOPES = %w[Question Answer Comment User].freeze

  def self.call(query:, scope: nil)
    query = ThinkingSphinx::Query.escape(query)
    return ThinkingSphinx.search(query) if SCOPES.exclude?(scope)

    ThinkingSphinx.search(query, classes: [scope.constantize])
  end
end
