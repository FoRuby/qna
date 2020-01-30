class SearchService
  SCOPES = %w[Question Answer Comment User].freeze

  def self.call(search_string, search_scope)
    return ThinkingSphinx.search(search_string) if search_scope.empty?
    return if SCOPES.exclude? search_scope

    ThinkingSphinx
      .search(search_string, classes: [search_scope.classify.constantize])
  end
end
