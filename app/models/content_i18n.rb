class ContentI18n < ActiveRecord::Base
  set_table_name "contents_i18n"

  belongs_to :content

end