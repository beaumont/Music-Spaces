module SiteActivityLoggerForModels

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def acts_as_logging
      after_save :write_site_activity_log
      before_save :store_changes

      include HTMLDiff
      include SiteActivityLoggerForModels::InstanceMethods

      attr_accessor :stored_changes
    end

  end

  module InstanceMethods
    private

    def store_changes
      self.stored_changes = self.changes
    end

    def write_site_activity_log
      return if !APP_CONFIG.enable_site_activity_log

      return if self.stored_changes.blank?

      configs = SiteActivityLogConfig.first
      return if configs.blank?
      return unless configs.monitoring

      return if current_user.blank?

      log_users = SiteActivityLogUser.all.map(& :user_id)
      return if !configs.all_users && !(log_users.include?(current_user.id) || log_users.include?(current_actor.id))

      SiteActivityLog.create(
              :login => current_user.login,
              :user_id => current_user.id,
              :actor_login => current_actor.login,
              :actor_id => current_actor.id,

              :content_type => self.type,
              :content_id => self.id,
              :content => prepare_content
      )
    rescue => e
      AdminNotifier.async_deliver_admin_alert("#{SiteActivityLoggerForModels.name}'s filter failed: #{e.inspect}")
    end

    def prepare_content
      changes = ""
      self.stored_changes.keys.each do |key|
        changes << "<b>#{key}:</b> "
        RAILS_DEFAULT_LOGGER.debug "#{'*' * 80} #{self.class}"
        changes << self.diff(self.stored_changes[key].first.to_s, self.stored_changes[key].last.to_s)
        changes << "<br />"
      end
      changes
    end
  end

end
