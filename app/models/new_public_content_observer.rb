class NewPublicContentObserver < ActiveRecord::Observer
  observe :content

  def after_create(content)
    if NewContent.valid_content?(content)
      NewContent.create!(:content_id => content.id)
    end
  end

  def after_update(content)
    return unless NewContent.in_window?(content.id)
    existing = NewContent.find_by_content_id(content.id)
    valid = NewContent.valid_content?(content)
    existing.destroy if existing && !valid
    NewContent.create!(:content_id => content.id) if !existing && valid 
  end

  def after_destroy(content)
    return unless NewContent.in_window?(content.id)
    existing = NewContent.find_by_content_id(content.id)
    existing.destroy if existing
  end
end
