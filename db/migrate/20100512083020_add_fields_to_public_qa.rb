class AddFieldsToPublicQa < ActiveRecord::Migration
  def self.up
    #no default please. let empty be NULL
    change_column 'public_questions', :text, :string, :default => nil
    change_column 'public_answers', :text, :string, :default => nil

    #Q should be bilingual
    add_column 'public_questions', 'text_ru', :string

    #can be used to figure who of project hosts did that
    add_column 'public_questions', 'created_by_id', :integer
    add_column 'public_questions', 'updated_by_id', :integer
    add_column 'public_answers', 'created_by_id', :integer
    add_column 'public_answers', 'updated_by_id', :integer
  end

  def self.down
  end
end
