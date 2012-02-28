module SearchHelper
  def for_query(query)
    raw "for &quot;#{content_tag :strong, query}&quot;"
  end
end
