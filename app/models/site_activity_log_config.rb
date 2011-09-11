class SiteActivityLogConfig < ActiveRecord::Base

  set_table_name :activity_log_configs
  validate :single_config

  private

  def single_config
    errors.add(:id, "config already exists") if self.new_record? && SiteActivityLogConfig.count > 0
  end

end