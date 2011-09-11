module TagsHelper
  # See the README for an example using tag_cloud.
  def tag_cloud(tags, classes)
    max_count = (tags.nil? || tags.empty?) ? 0.to_f : tags.sort_by(&:count).last.count.to_f
    
    # 1. We got a undefined method tags.empty for nil. 2., if max_count is 0 we should get a division by zero error
    # Instead, just don't yield
    return unless max_count > 0
    
    tags.each do |tag|
      index = ((tag.count / max_count) * (classes.size - 1)).round
      yield tag, classes[index]
    end
  end
  
end
