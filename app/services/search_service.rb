class SearchService
  SCOPES = %w[Question Answer Comment User].freeze

  def self.call(search_string, search_scope)
    # TODO: мб вместо пустого массива возвращать nil,
    #   типа если nil, то некоректный запрос,
    #   в контроллере бахнкть флеш и не рендерить search.slim

    return [] if search_string.empty?

    query = ThinkingSphinx::Query.escape(search_string)
    return ThinkingSphinx.search(query) if search_scope.empty?
    return [] if SCOPES.exclude? search_scope

    ThinkingSphinx.search(query, classes: [search_scope.classify.constantize])
  end
end
