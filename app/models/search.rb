class Search
  CONTEXTS = ['Questions', 'Answers', 'Comments', 'Users']

  def self.scan(query, context)
    query = ThinkingSphinx::Query.escape(query)
    klasses = [context.singularize.constantize] if CONTEXTS.include?(context)
    @results = ThinkingSphinx.search(query, classes: klasses) if query.present?
  end
end
