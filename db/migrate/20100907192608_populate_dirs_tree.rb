class PopulateDirsTree < ActiveRecord::Migration
  def self.up
    unless %w(production test).include?(RAILS_ENV)
      collection_records = YAML.load_file(File.join(File.dirname(__FILE__), 'data', 'collections.yml'))
      miro = User.find_by_login('chief')
      return unless miro #give up
      Thread.current['user'] = miro
      
      collection_records.each do |attributes|
        if col = User.find_by_login(attributes['login'])
          next if col.is_a?(CollectionProject)
          col.update_attribute(:type, 'CollectionProject')
          col = User.find(col.id)
        else
          col = CollectionProject.create!(attributes)
        end
        col.founders << miro
      end

      pac_records = YAML.load_file(File.join(File.dirname(__FILE__), 'data', 'pacs.yml'))
      pac_records.each do |attributes|
        child_login = attributes.delete('body_project_login')
        user = User.find_by_login(child_login)
        raise "pac's child user '#{child_login}' not found" unless user
        attributes['body_project_id'] = user.id

        login = attributes.delete('container_login')
        user = User.find_by_login(login)
        raise "pac's container '#{login}' not found" unless user
        attributes['user_id'] = user.id

        next if ProjectAsContent.find(:first, :conditions => ['user_id = ? and body_project_id = ?', attributes['user_id'], attributes['body_project_id']])
        ProjectAsContent.create!(attributes.merge(:body_project_name => child_login))
      end

      CollectionProject.repopulate_all_inclusions(:stdout_progress => true)
    end
  end

  def self.down
  end
end
