require "yaml"

class ChangeGlobalizeBaseClass < ActiveRecord::Migration
  def self.up
    conn = ActiveRecord::Base.connection
    obj = conn.select_all("select * from `globalize_translations` where type = 'Globalize::ViewTranslation'")
    fname = "#{RAILS_ROOT}/db/translations/old_globalize_viewtrans.yaml"
    File.open(fname, "w") { |file| YAML.dump(obj, file) } unless File.exist?(fname)
    del = conn.delete("delete from `globalize_translations` where type = 'Globalize::ViewTranslation'")
    puts "Deleted: #{del} from globalize_translations  (copies dumped to '#{fname}')"
    upd = conn.update("update `globalize_translations` set type = 'Globalize::ViewTranslation' where type = 'ViewTranslation'")
    puts "Updated: #{upd} to have new class"
    `svn propset svn:ignore '#{File.basename(fname)}' #{File.dirname(fname)}`
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
