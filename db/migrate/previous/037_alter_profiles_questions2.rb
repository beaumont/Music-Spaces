class AlterProfilesQuestions2 < ActiveRecord::Migration
  def self.up
    add_column :profile_questions, 'is_public', :boolean, :default => false
    remove_column :profiles, "date_of_birth"
    remove_column :profiles, "location"
    remove_column :profiles, "is_req_translation"
    remove_column :profiles, "bio_id"
    add_column :invites, :activation_code, :string, :limit => 40
    add_column :invites, :activated_at, :datetime
    add_column :invites, :display_name, :string
    add_column :invites, :role_name, :string
    add_column :invites, :invitation_type, :string
  end

  def self.down
    remove_column :invites, :activation_code
    remove_column :invites, :activated_at
    remove_column :invites, :display_name
    remove_column :invites, :role_name
    remove_column :invites, :invitation_type
    remove_column :profile_questions, "is_public"
    add_column :profiles, "date_of_birth", :datetime
    add_column :profiles, "location", :string
    add_column :profiles, "is_req_translation", :boolean, :default => false
    add_column :profiles, "bio_id", :integer
  end
end
