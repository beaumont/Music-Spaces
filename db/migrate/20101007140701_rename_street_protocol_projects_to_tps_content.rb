class RenameStreetProtocolProjectsToTpsContent < ActiveRecord::Migration

  def self.rename_class(from_class, to_class)
    Content.update_all(['type = ?', to_class], ['type = ?', from_class])
    [[FeaturedItem, 'item_type'], [Comment, 'commentable_type'],
     [Favorite, 'favorable_type'], [Moderation::Event, 'reportable_type'],
     [SmsPayload, 'payment_for_type']].each do |klass, type_field|
      klass.update_all ['%s = ?' % type_field, to_class], ['%s = ?' % type_field, from_class]
    end

    [Activity, ContentStat, Stat].each do |klass|
      klass.update_all ['content_type = ?', to_class], ['content_type = ?', from_class]
    end
  end

  def self.up
    rename_class('StreetProtocolProject', 'TpsContent')
    rename_class('StreetProtocolProjectDetails', 'TpsContentDetails')
    rename_table 'street_protocol_project_details', 'tps_content_details'
  end

  def self.down
  end
end
