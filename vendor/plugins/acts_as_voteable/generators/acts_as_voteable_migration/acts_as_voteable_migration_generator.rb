class ActsAsVoteableMigrationGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      unless options[:skip_migration]
        m.migration_template(
          'migration.rb', 'db/migrate', :migration_file_name => 'create_votes'
        )
      end
    end
  end
end