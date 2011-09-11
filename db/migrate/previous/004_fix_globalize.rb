class FixGlobalize < ActiveRecord::Migration
  def self.up
    include Globalize
    ViewTranslation.update_all "built_in = true" 
  end

  def self.down
  end
end