#I've tried AAC upload and it had 'Single Channel', 
# bit more than 10 symbols the field had!
class MakeContentsChanelsColumnBigger < ActiveRecord::Migration
  def self.up
    change_column :contents, :chanels, :string, :limit => 20
  end

  def self.down
  end
end
