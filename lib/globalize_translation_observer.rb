class GlobalizeTranslationObserver < ActiveRecord::Observer
  observe :globalize_translation

  def before_update(translation)
    log.debug "hello from before_update. translation.changed: %s" % translation.changed?
    translation.to_dump = true if translation.changed?
  end
end
