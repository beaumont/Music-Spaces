class AddingTagLine < ActiveRecord::Migration
  def self.up
    add_column :profiles, :tagline, :string
    add_column :profiles, :tagline_ru, :string
  end

  def self.down
    remove_column :profiles, :tagline
    remove_column :profiles, :tagline_ru
  end
end
