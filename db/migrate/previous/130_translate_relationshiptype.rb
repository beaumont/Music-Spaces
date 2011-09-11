class TranslateRelationshiptype < ActiveRecord::Migration
  def self.up
    add_column :relationshiptypes, :name_ru, :string
    
    Relationshiptype.find(-2).update_attribute(:name_ru, 'Всем')
    Relationshiptype.find(-1).update_attribute(:name_ru, 'Личное')
    Relationshiptype.find(0).update_attribute(:name_ru, 'Основатели')
    Relationshiptype.find(1).update_attribute(:name_ru, 'Семья')
    Relationshiptype.find(2).update_attribute(:name_ru, 'За кулисами')
    Relationshiptype.find(3).update_attribute(:name_ru, 'Первый ряд')
    Relationshiptype.find(4).update_attribute(:name_ru, 'Фан-клуб')
    Relationshiptype.find(5).update_attribute(:name_ru, 'Зрители')
    Relationshiptype.find(7).update_attribute(:name_ru, 'Зрители')
  end

  def self.down
    remove_column :relationshiptypes, :name_ru
  end
end
