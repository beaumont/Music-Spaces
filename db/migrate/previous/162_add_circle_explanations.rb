class AddCircleExplanations < ActiveRecord::Migration
  def self.up
    add_column :relationshiptypes, :explanation_db_store_id,     :integer
    add_column :relationshiptypes, :explanation_ru_db_store_id,  :integer
    
    Relationshiptype.find_by_id(1).update_attribute(:explanation, "Use this circle for those followers who have an immediate connection to you. Members of this circle will have access everything posted for other circles.")
    
    Relationshiptype.find_by_id(2).update_attribute(:explanation, "Use this circle as one of the middle circles in your followers structure. If you want to use circles with a subscription fee, it should be one of these circles.")
    
    Relationshiptype.find_by_id(3).update_attribute(:explanation, "Use this circle as one of the middle circles in your followers structure. If you want to use circles with a subscription fee, it should be one of these circles.")
    
    Relationshiptype.find_by_id(4).update_attribute(:explanation, "Use this circle as one of the middle circles in your followers structure. If you want to use circles with a subscription fee, it should be one of these circles.")
    
    Relationshiptype.find_by_id(5).update_attribute(:explanation, "Use this circle for people who are willing to express their interest in you and simply read your updates on their homepage. We do not recommend making this circle paid or by invitation only.")
  end

  def self.down
    remove_column :relationshiptypes, :explanation_db_store_id
    remove_column :relationshiptypes, :explanation_ru_db_store_id
  end
end
