# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110228102314) do

  create_table "account_settings", :force => true do |t|
    t.column "user_id",                         :integer
    t.column "paypal_email",                    :string,   :limit => 50
    t.column "donation_title",                  :string,                                                :default => "Please support our project!"
    t.column "donation_button_label",           :string,                                                :default => "Contribute"
    t.column "donation_request_explanation",    :text
    t.column "donation_amount",                 :decimal,                :precision => 10, :scale => 2
    t.column "show_donation_basket",            :boolean,                                               :default => false
    t.column "default_language",                :string,                                                :default => "1819"
    t.column "created_at",                      :datetime
    t.column "updated_at",                      :datetime
    t.column "money_status",                    :string
    t.column "webmoney_wmz",                    :string
    t.column "webmoney_wme",                    :string
    t.column "webmoney_wmr",                    :string
    t.column "allow_sponsorships",              :boolean,                                               :default => false
    t.column "donation_title_ru",               :string,                                                :default => "Пожалуйста поддержите наш проект!"
    t.column "donation_button_label_ru",        :string,                                                :default => "Поблагодарит\321\214"
    t.column "donation_request_explanation_ru", :text
    t.column "donation_title_fr",               :string
    t.column "donation_button_label_fr",        :string
    t.column "donation_request_explanation_fr", :text
    t.column "notified_of_delay",               :boolean,                                               :default => false
    t.column "yandex_scid",                     :string
    t.column "yandex_shopid",                   :string
    t.column "allow_yandex",                    :boolean,                                               :default => false
    t.column "paypal_transaction",              :string
    t.column "webmoney_account",                :string
    t.column "webmoney_passport_minimum",       :integer
    t.column "webmoney_account_verified",       :boolean
    t.column "webmoney_wmz_attached",           :boolean
    t.column "webmoney_wmr_attached",           :boolean
    t.column "webmoney_wme_attached",           :boolean
    t.column "paypal_status",                   :string
    t.column "paypal_status_last_updated_at",   :datetime
    t.column "paypal_status_last_updated_by",   :integer
    t.column "verified_by_kroogi",              :boolean,                                               :default => false
    t.column "webmoney_attached_at",            :datetime
    t.column "webmoney_passport_level",         :integer
    t.column "paypal_user_id",                  :string
    t.column "paypal_denial_reason",            :string
    t.column "billable",                        :boolean,                                               :default => false
    t.column "invoice_agreement_accepted_at",   :datetime
    t.column "collected_usd",                   :decimal,                :precision => 11, :scale => 2, :default => 0.0
    t.column "balance_usd",                     :decimal,                :precision => 11, :scale => 2, :default => 0.0
    t.column "waiting_period",                  :integer
    t.column "movable_broker_enabled",          :boolean,                                               :default => true,                                                             :null => false
    t.column "minimum_withdrawal_amount",       :decimal,                :precision => 8,  :scale => 2
    t.column "withdrawal_limit",                :integer
  end

  add_index "account_settings", ["paypal_status"], :name => "index_account_settings_on_paypal_status"
  add_index "account_settings", ["user_id"], :name => "index_account_settings_on_user_id"

  create_table "accounts", :force => true do |t|
    t.column "user_id",          :integer,                                     :null => false
    t.column "crypted_password", :string,   :default => "",                    :null => false
    t.column "verified",         :boolean,  :default => false
    t.column "last_sync",        :datetime, :default => '1970-01-01 00:00:00'
    t.column "created_at",       :datetime
    t.column "updated_at",       :datetime
    t.column "login",            :string
    t.column "connect_friends",  :boolean,  :default => true
    t.column "last_manual_sync", :datetime
    t.column "usejournal",       :string
    t.column "friend_circle",    :integer
    t.column "allow_friends",    :boolean
    t.column "import_mine",      :boolean,  :default => false
  end

  add_index "accounts", ["user_id"], :name => "index_accounts_on_user_id"

  create_table "activities", :force => true do |t|
    t.column "user_id",                 :integer,                                   :null => false
    t.column "activity_type_id",        :integer
    t.column "status",                  :integer,                :default => 1,     :null => false
    t.column "db_file_id",              :integer
    t.column "from_user_id",            :integer
    t.column "from_username",           :string,   :limit => 30
    t.column "content_id",              :integer
    t.column "content_type",            :string,   :limit => 32
    t.column "created_at",              :datetime,                                  :null => false
    t.column "updated_at",              :datetime,                                  :null => false
    t.column "friendcast",              :boolean,                :default => false
    t.column "monetary_transaction_id", :integer
    t.column "from_related",            :boolean
    t.column "show",                    :boolean,                :default => true
  end

  add_index "activities", ["content_id"], :name => "activities_content_id"
  add_index "activities", ["created_at"], :name => "index_activities_on_created_at"
  add_index "activities", ["from_user_id", "created_at"], :name => "index_activities_on_from_user_id_and_created_at"
  add_index "activities", ["user_id", "from_user_id", "activity_type_id", "status"], :name => "activity_idx"

  create_table "activity_counts", :force => true do |t|
    t.column "user_id",          :integer,                :null => false
    t.column "activity_type_id", :integer
    t.column "total",            :integer, :default => 0, :null => false
    t.column "unread",           :integer, :default => 0, :null => false
  end

  add_index "activity_counts", ["user_id", "activity_type_id"], :name => "index_activity_counts_on_user_id_and_activity_count_id"

  create_table "activity_log_configs", :force => true do |t|
    t.column "monitoring", :boolean,  :default => false
    t.column "guests",     :boolean
    t.column "bots",       :boolean
    t.column "all_users",  :boolean,  :default => true
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "activity_log_even", :force => true do |t|
    t.column "created_at",          :datetime
    t.column "updated_at",          :datetime
    t.column "ip",                  :string,   :limit => 16,  :default => ""
    t.column "url",                 :string,                  :default => ""
    t.column "path",                :string,                  :default => ""
    t.column "referrer",            :string,                  :default => ""
    t.column "user_agent",          :string,                  :default => ""
    t.column "session_id",          :string,   :limit => 50,  :default => ""
    t.column "login",               :string,                  :default => ""
    t.column "user_id",             :integer
    t.column "actor_login",         :string,                  :default => ""
    t.column "actor_id",            :integer
    t.column "system_message_type", :string,                  :default => ""
    t.column "admin_flash_id",      :integer
    t.column "content_type",        :string,   :limit => 50,  :default => ""
    t.column "content_id",          :integer
    t.column "content",             :text
    t.column "accept_language",     :string,   :limit => 100
  end

  create_table "activity_log_odd", :force => true do |t|
    t.column "created_at",          :datetime
    t.column "updated_at",          :datetime
    t.column "ip",                  :string,   :limit => 16,  :default => ""
    t.column "url",                 :string,                  :default => ""
    t.column "path",                :string,                  :default => ""
    t.column "referrer",            :string,                  :default => ""
    t.column "user_agent",          :string,                  :default => ""
    t.column "session_id",          :string,   :limit => 50,  :default => ""
    t.column "login",               :string,                  :default => ""
    t.column "user_id",             :integer
    t.column "actor_login",         :string,                  :default => ""
    t.column "actor_id",            :integer
    t.column "system_message_type", :string,                  :default => ""
    t.column "admin_flash_id",      :integer
    t.column "content_type",        :string,   :limit => 50,  :default => ""
    t.column "content_id",          :integer
    t.column "content",             :text
    t.column "accept_language",     :string,   :limit => 100
  end

  create_table "activity_log_users", :force => true do |t|
    t.column "user_id",    :integer
    t.column "login",      :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "activity_mails", :force => true do |t|
    t.column "activity_id", :integer
    t.column "user_id",     :integer
    t.column "created_at",  :datetime
    t.column "updated_at",  :datetime
    t.column "payload",     :string
  end

  add_index "activity_mails", ["activity_id"], :name => "index_activity_mails_on_activity_id"
  add_index "activity_mails", ["user_id", "created_at"], :name => "index_activity_mails_on_user_id_and_created_at"

  create_table "admin_flashes", :force => true do |t|
    t.column "message",    :string
    t.column "start",      :datetime
    t.column "end",        :datetime
    t.column "priority",   :integer,  :default => 0
    t.column "shown",      :boolean,  :default => true
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "message_ru", :string
  end

  add_index "admin_flashes", ["shown", "priority"], :name => "index_admin_flashes_on_shown_and_priority"

  create_table "admission_pass_name_list", :force => true do |t|
    t.column "name", :string
  end

  add_index "admission_pass_name_list", ["name"], :name => "index_admission_pass_name_list_on_name"

  create_table "album_items", :force => true do |t|
    t.column "album_id",      :integer
    t.column "content_id",    :integer
    t.column "position",      :integer,  :default => 0
    t.column "created_by_id", :integer,  :default => 0, :null => false
    t.column "created_at",    :datetime
    t.column "updated_at",    :datetime
  end

  add_index "album_items", ["album_id", "position"], :name => "index_album_items_on_album_id_and_position"

  create_table "announcements", :force => true do |t|
    t.column "board_id",                      :integer
    t.column "created_at",                    :datetime
    t.column "updated_at",                    :datetime
    t.column "generate_donor_coupons",        :boolean,  :default => false
    t.column "require_minimum_to_get_coupon", :boolean,  :default => true
    t.column "coupon_expiration_date",        :date
    t.column "max_coupons",                   :integer
    t.column "priority",                      :boolean,  :default => false, :null => false
    t.column "reason_for_kroogi_pass",        :text
    t.column "reason_for_kroogi_pass_ru",     :text
    t.column "reason_for_kroogi_pass_fr",     :text
  end

  add_index "announcements", ["board_id"], :name => "index_announcements_on_board_id"
  add_index "announcements", ["generate_donor_coupons"], :name => "index_announcements_on_generate_donor_coupons"

  create_table "answer_interval_counters", :force => true do |t|
    t.column "user_id",   :integer, :null => false
    t.column "artist_id", :integer, :null => false
    t.column "counter",   :integer, :null => false
  end

  add_index "answer_interval_counters", ["artist_id", "user_id"], :name => "index_answer_interval_counters_on_artist_id_and_user_id", :unique => true

  create_table "audits", :force => true do |t|
    t.column "auditable_id",   :integer
    t.column "auditable_type", :string
    t.column "user_id",        :integer
    t.column "user_type",      :string
    t.column "username",       :string
    t.column "action",         :string
    t.column "changes",        :text
    t.column "version",        :integer,  :default => 0
    t.column "created_at",     :datetime
  end

  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "bdrb_job_queues", :force => true do |t|
    t.column "args",           :binary
    t.column "worker_name",    :string
    t.column "worker_method",  :string
    t.column "job_key",        :string
    t.column "taken",          :integer,  :limit => 8
    t.column "finished",       :integer,  :limit => 8
    t.column "timeout",        :integer,  :limit => 8
    t.column "priority",       :integer,  :limit => 8
    t.column "submitted_at",   :datetime
    t.column "started_at",     :datetime
    t.column "finished_at",    :datetime
    t.column "archived_at",    :datetime
    t.column "tag",            :string
    t.column "submitter_info", :string
    t.column "runner_info",    :string
    t.column "worker_key",     :string
    t.column "scheduled_at",   :datetime
  end

  add_index "bdrb_job_queues", ["worker_name", "scheduled_at"], :name => "index_bdrb_job_queues_on_worker_name_and_scheduled_at"

  create_table "blocked_emails", :force => true do |t|
    t.column "email",              :string,   :null => false
    t.column "created_at",         :datetime
    t.column "updated_at",         :datetime
    t.column "created_by_id",      :integer
    t.column "updated_by_id",      :integer
    t.column "blocked_because_of", :string
  end

  add_index "blocked_emails", ["email"], :name => "index_blocked_emails_on_email", :unique => true

  create_table "blocked_users", :force => true do |t|
    t.column "blocked_by_id",   :integer
    t.column "blocked_user_id", :integer
    t.column "blocked_type",    :string,   :limit => 20
    t.column "created_at",      :datetime
    t.column "updated_at",      :datetime
  end

  create_table "collection_inclusions", :force => true do |t|
    t.column "parent_id",           :integer,                    :null => false
    t.column "child_pac_id",        :integer,                    :null => false
    t.column "child_user_id",       :integer,                    :null => false
    t.column "direct_parent_id",    :integer,                    :null => false
    t.column "child_is_collection", :boolean,                    :null => false
    t.column "stopped",             :boolean, :default => false, :null => false
  end

  add_index "collection_inclusions", ["child_pac_id"], :name => "index_collection_inclusions_on_child_pac_id"
  add_index "collection_inclusions", ["child_user_id"], :name => "index_collection_inclusions_on_child_user_id"
  add_index "collection_inclusions", ["parent_id", "child_is_collection"], :name => "index_collection_inclusions_on_parent_id_and_child_is_collection"

  create_table "collection_stop_list_items", :force => true do |t|
    t.column "parent_id", :integer, :null => false
    t.column "child_id",  :integer, :null => false
  end

  add_index "collection_stop_list_items", ["parent_id", "child_id"], :name => "index_collection_stop_list_items_on_parent_id_and_child_id"

  create_table "comments", :force => true do |t|
    t.column "title",            :string,   :limit => 50, :default => ""
    t.column "created_at",       :datetime,                                  :null => false
    t.column "commentable_id",   :integer,                :default => 0,     :null => false
    t.column "commentable_type", :string,   :limit => 32, :default => ""
    t.column "user_id",          :integer,                :default => 0,     :null => false
    t.column "comments_count",   :integer,                :default => 0,     :null => false
    t.column "parent_id",        :integer
    t.column "lft",              :integer
    t.column "rgt",              :integer
    t.column "created_by_id",    :integer,                :default => 0,     :null => false
    t.column "avatar_id",        :integer
    t.column "db_store_id",      :integer
    t.column "deleted_at",       :datetime
    t.column "deleted_by",       :integer
    t.column "private",          :boolean,                :default => false
  end

  add_index "comments", ["commentable_type", "commentable_id", "deleted_at", "parent_id"], :name => "tuned_comment_index"
  add_index "comments", ["created_at"], :name => "index_comments_on_created_at"
  add_index "comments", ["parent_id"], :name => "index_comments_on_parent_id"
  add_index "comments", ["user_id"], :name => "fk_comments_user"

  create_table "configurations", :force => true do |t|
    t.column "config_key",  :string
    t.column "description", :text
    t.column "value",       :text
    t.column "created_at",  :datetime
    t.column "updated_at",  :datetime
  end

  add_index "configurations", ["config_key"], :name => "index_configurations_on_config_key"

  create_table "content_import_details", :force => true do |t|
    t.column "original_content_id", :integer, :null => false
    t.column "previous_content_id", :integer, :null => false
    t.column "previous_owner_id",   :integer, :null => false
    t.column "inbox_id",            :integer, :null => false
    t.column "content_id",          :integer
    t.column "new_owner_id",        :integer, :null => false
  end

  add_index "content_import_details", ["content_id"], :name => "content_import_details_unique_content_id", :unique => true
  add_index "content_import_details", ["original_content_id"], :name => "content_import_details_original_content_id"

  create_table "content_stats", :force => true do |t|
    t.column "content_id",      :integer
    t.column "viewed",          :integer
    t.column "viewed_today",    :integer
    t.column "favorited",       :integer
    t.column "favorited_today", :integer
    t.column "commented",       :integer
    t.column "commented_today", :integer
    t.column "played",          :integer
    t.column "played_today",    :integer
    t.column "content_type",    :string,  :limit => 32
  end

  add_index "content_stats", ["content_type", "content_id"], :name => "index_content_stats_on_content_type_and_content_id"

  create_table "contents", :force => true do |t|
    t.column "user_id",               :integer,                                      :null => false
    t.column "title",                 :string
    t.column "description",           :text
    t.column "type",                  :string
    t.column "content_type",          :string
    t.column "filename",              :string
    t.column "filepath",              :string
    t.column "size",                  :integer
    t.column "parent_id",             :integer
    t.column "thumbnail",             :string
    t.column "width",                 :integer
    t.column "height",                :integer
    t.column "created_at",            :datetime,                                     :null => false
    t.column "updated_at",            :datetime,                                     :null => false
    t.column "is_in_gallery",         :boolean,                :default => false
    t.column "db_file_id",            :integer
    t.column "foruser_id",            :integer
    t.column "cat_id",                :integer,                :default => 0,        :null => false
    t.column "is_in_startpage",       :boolean,                :default => false
    t.column "is_in_myplaylist",      :boolean,                :default => false
    t.column "created_by_id",         :integer,                :default => 0,        :null => false
    t.column "updated_by_id",         :integer,                :default => 0,        :null => false
    t.column "author_id",             :integer,                :default => 0,        :null => false
    t.column "artist",                :string,   :limit => 80
    t.column "album",                 :string,   :limit => 80
    t.column "year",                  :integer
    t.column "genre",                 :string,   :limit => 60
    t.column "bitrate",               :integer
    t.column "chanels",               :string,   :limit => 20
    t.column "samplerate",            :integer
    t.column "length",                :integer
    t.column "post_db_store_id",      :integer
    t.column "language_code",         :string,   :limit => 8
    t.column "owner",                 :string
    t.column "title_ru",              :string
    t.column "description_ru",        :text
    t.column "title_fr",              :string
    t.column "description_fr",        :text
    t.column "post_db_store_ru_id",   :integer
    t.column "post_db_store_fr_id",   :integer
    t.column "state",                 :string,                 :default => "active"
    t.column "state_changed_at",      :datetime
    t.column "artist_ru",             :string
    t.column "album_ru",              :string
    t.column "artist_fr",             :string
    t.column "album_fr",              :string
    t.column "downloadable",          :boolean,                :default => false
    t.column "downloadable_album_id", :integer
    t.column "relationshiptype_id",   :integer
    t.column "body_project_id",       :integer
    t.column "original_owner",        :string
    t.column "popularity",            :float,                  :default => 0.0
  end

  add_index "contents", ["original_owner"], :name => "index_contents_on_original_owner"
  add_index "contents", ["parent_id"], :name => "index_contents_on_parent_id"
  add_index "contents", ["popularity"], :name => "index_contents_on_popularity"
  add_index "contents", ["state"], :name => "index_contents_on_state"
  add_index "contents", ["type", "created_at"], :name => "index_contents_on_type_and_created_at"
  add_index "contents", ["type", "downloadable"], :name => "index_contents_on_type_and_downloadable"
  add_index "contents", ["user_id"], :name => "index_contents_on_user_id"

  create_table "contents_i18n", :force => true do |t|
    t.column "content_id",        :integer
    t.column "updated_by_id",     :integer
    t.column "hide_from_eng_top", :boolean,  :default => false, :null => false
    t.column "created_at",        :datetime
    t.column "updated_at",        :datetime
  end

  add_index "contents_i18n", ["content_id"], :name => "index_contents_i18n_on_content_id", :unique => true

  create_table "contest_submissions", :force => true do |t|
    t.column "content_id",    :integer
    t.column "level",         :integer,  :null => false
    t.column "created_by_id", :integer
    t.column "updated_by_id", :integer
    t.column "created_at",    :datetime
    t.column "updated_at",    :datetime
    t.column "contest_id",    :integer
  end

  add_index "contest_submissions", ["content_id"], :name => "index_contest_submissions_on_content_id"
  add_index "contest_submissions", ["contest_id"], :name => "index_contest_submissions_on_contest_id"
  add_index "contest_submissions", ["created_by_id"], :name => "index_contest_submissions_on_created_by_id"

  create_table "contribution_settings", :force => true do |t|
    t.column "content_id",         :integer,                                :null => false
    t.column "min_amount",         :decimal, :precision => 10, :scale => 2
    t.column "recommended_amount", :decimal, :precision => 10, :scale => 2
  end

  add_index "contribution_settings", ["content_id"], :name => "index_contribution_settings_on_content_id"

  create_table "db_files", :force => true do |t|
    t.column "data", :binary
  end

  create_table "db_store", :force => true do |t|
    t.column "content",       :text
    t.column "updated_by_id", :integer
    t.column "updated_at",    :datetime
  end

  create_table "donation_settings", :force => true do |t|
    t.column "accountable_id",                        :integer
    t.column "accountable_type",                      :string,                                  :default => "AccountSetting"
    t.column "roubles",                               :decimal,  :precision => 10, :scale => 2
    t.column "euros",                                 :decimal,  :precision => 10, :scale => 2
    t.column "dollars",                               :decimal,  :precision => 10, :scale => 2
    t.column "created_at",                            :datetime
    t.column "updated_at",                            :datetime
    t.column "sponsorship_prices",                    :boolean,                                 :default => false
    t.column "show_donation_button",                  :boolean,                                 :default => false
    t.column "donation_button_label",                 :string
    t.column "message_to_donors",                     :text
    t.column "message_to_donors_ru",                  :text
    t.column "donation_button_label_ru",              :string
    t.column "message_to_donors_fr",                  :text
    t.column "donation_button_label_fr",              :string
    t.column "amount_required_for_circle_invite_usd", :decimal,  :precision => 10, :scale => 2
    t.column "circle_to_invite_to",                   :integer
    t.column "amount_required_for_circle_invite_rur", :decimal,  :precision => 10, :scale => 2
    t.column "amount_required_for_circle_invite_eur", :decimal,  :precision => 10, :scale => 2
  end

  add_index "donation_settings", ["accountable_type", "accountable_id"], :name => "index_currency_types_on_accountable_type_and_accountable_id"

  create_table "donor_coupons", :force => true do |t|
    t.column "user_id",              :integer
    t.column "board_id",             :integer
    t.column "monetary_donation_id", :integer
    t.column "coupon_code",          :string
    t.column "message",              :text
    t.column "expires_at",           :date
    t.column "created_at",           :datetime
    t.column "updated_at",           :datetime
    t.column "access_key",           :string
  end

  add_index "donor_coupons", ["board_id", "monetary_donation_id"], :name => "relationship_to_contribution", :unique => true
  add_index "donor_coupons", ["user_id"], :name => "index_donor_coupons_on_user_id"

  create_table "emails", :force => true do |t|
    t.column "from",              :string
    t.column "to",                :string
    t.column "last_send_attempt", :integer,  :default => 0
    t.column "mail",              :text
    t.column "created_on",        :datetime
    t.column "ready",             :boolean,  :default => false, :null => false
  end

  create_table "event_invites", :force => true do |t|
    t.column "user_id",              :integer
    t.column "event_id",             :integer
    t.column "event_access_key",     :string
    t.column "message",              :text
    t.column "rsvp",                 :string
    t.column "created_at",           :datetime
    t.column "updated_at",           :datetime
    t.column "monetary_donation_id", :integer
  end

  add_index "event_invites", ["monetary_donation_id"], :name => "index_event_invites_on_monetary_contribution_id"
  add_index "event_invites", ["user_id", "event_id"], :name => "index_event_invites_on_user_id_and_event_id"

  create_table "events", :force => true do |t|
    t.column "max_attendees",    :integer
    t.column "title",            :string
    t.column "start_date",       :date
    t.column "end_date",         :date
    t.column "description",      :text
    t.column "category",         :integer
    t.column "homepage",         :string
    t.column "number_of_guests", :integer
    t.column "board_id",         :integer
    t.column "created_at",       :datetime
    t.column "updated_at",       :datetime
    t.column "venue_id",         :integer
    t.column "start_time",       :time
    t.column "end_time",         :time
  end

  create_table "extra_folder_with_downloadables_fields", :force => true do |t|
    t.column "folder_id",                      :integer
    t.column "require_terms_acceptance",       :boolean,  :default => false
    t.column "number_of_tracks",               :string
    t.column "terms_db_store_id",              :integer
    t.column "terms_db_store_ru_id",           :integer
    t.column "preset_terms_and_conditions_id", :integer
    t.column "created_at",                     :datetime
    t.column "updated_at",                     :datetime
    t.column "terms_and_conditions_id",        :integer
  end

  add_index "extra_folder_with_downloadables_fields", ["folder_id"], :name => "index_extra_music_album_fields_on_music_album_id"

  create_table "extra_inbox_fields", :force => true do |t|
    t.column "inbox_id",                          :integer
    t.column "tagline",                           :string
    t.column "tagline_ru",                        :string
    t.column "tagline_fr",                        :string
    t.column "images",                            :boolean,  :default => true
    t.column "tracks",                            :boolean,  :default => true
    t.column "videos",                            :boolean,  :default => true
    t.column "writings",                          :boolean,  :default => true
    t.column "archived",                          :boolean,  :default => false
    t.column "feature_most_recent",               :boolean,  :default => false
    t.column "created_at",                        :datetime
    t.column "updated_at",                        :datetime
    t.column "require_allowing_content_adoption", :boolean,  :default => false
    t.column "voting_restriction",                :integer,  :default => -2
  end

  add_index "extra_inbox_fields", ["inbox_id"], :name => "index_extra_inbox_fields_on_inbox_id"

  create_table "facebook_templates", :force => true do |t|
    t.column "bundle_id",     :string
    t.column "template_name", :string
    t.column "created_at",    :datetime
    t.column "updated_at",    :datetime
  end

  create_table "faqs", :force => true do |t|
    t.column "question",    :string
    t.column "answer",      :text
    t.column "created_at",  :datetime
    t.column "updated_at",  :datetime
    t.column "question_ru", :string
    t.column "answer_ru",   :text
  end

  create_table "favorites", :force => true do |t|
    t.column "user_id",        :integer
    t.column "favorable_type", :string,   :limit => 30
    t.column "favorable_id",   :integer
    t.column "created_at",     :datetime
    t.column "updated_at",     :datetime
    t.column "created_by_id",  :integer,                :default => 0, :null => false
  end

  add_index "favorites", ["user_id", "created_at"], :name => "index_favorites_on_user_id_and_created_at"

  create_table "fb_friends", :force => true do |t|
    t.column "uid",        :string
    t.column "name",       :string
    t.column "user_id",    :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "fb_user_details", :force => true do |t|
    t.column "user_id",          :integer
    t.column "fb_user_id",       :integer, :limit => 8
    t.column "fb_session_key",   :string
    t.column "linked_artist_id", :integer
    t.column "header_text",      :text
    t.column "is_kd_user",       :boolean,              :default => false
    t.column "is_fb_connected",  :boolean,              :default => false
  end

  create_table "featured_items", :force => true do |t|
    t.column "item_id",                  :integer
    t.column "item_type",                :string
    t.column "is_content",               :boolean
    t.column "is_project",               :boolean
    t.column "currently_featured",       :boolean
    t.column "created_at",               :datetime
    t.column "updated_at",               :datetime
    t.column "editorial_db_store_id",    :integer
    t.column "editorial_db_store_ru_id", :integer
    t.column "synopsis",                 :string
    t.column "synopsis_ru",              :string
  end

  add_index "featured_items", ["currently_featured", "is_content", "is_project"], :name => "featured_item_idx"
  add_index "featured_items", ["currently_featured"], :name => "index_featured_items_on_currently_featured"
  add_index "featured_items", ["editorial_db_store_ru_id"], :name => "index_featured_items_on_db_store_ru_id"

  create_table "feed_entries", :force => true do |t|
    t.column "to_user_id",       :integer,                     :null => false
    t.column "content_category", :integer
    t.column "from_collections", :boolean,  :default => false, :null => false
    t.column "created_at",       :datetime
    t.column "updated_at",       :datetime
  end

  add_index "feed_entries", ["to_user_id", "created_at"], :name => "index_feed_entries_on_to_user_id_and_created_at"

  create_table "feed_entries_archive", :force => true do |t|
    t.column "to_user_id",       :integer,                     :null => false
    t.column "content_category", :integer
    t.column "from_collections", :boolean,  :default => false, :null => false
    t.column "created_at",       :datetime
    t.column "updated_at",       :datetime
  end

  create_table "feed_entry_activities", :force => true do |t|
    t.column "feed_entry_id",    :integer, :null => false
    t.column "activity_type_id", :integer
    t.column "content_id",       :integer
    t.column "content_type",     :string
    t.column "activity_id",      :integer, :null => false
    t.column "position",         :integer
    t.column "from_user_id",     :integer
    t.column "to_user_id",       :integer
  end

  add_index "feed_entry_activities", ["activity_id"], :name => "index_feed_entry_activities_on_activity_id"
  add_index "feed_entry_activities", ["activity_type_id", "content_type", "content_id"], :name => "feed_entry_activities_by_type_and_content"
  add_index "feed_entry_activities", ["content_type", "content_id"], :name => "index_feed_entry_activities_on_content"
  add_index "feed_entry_activities", ["feed_entry_id"], :name => "index_feed_entry_activities_on_feed_entry_id"
  add_index "feed_entry_activities", ["from_user_id", "feed_entry_id"], :name => "index_feed_entry_activities_on_from_user_id_and_feed_entry_id"
  add_index "feed_entry_activities", ["to_user_id", "from_user_id"], :name => "index_feed_entry_activities_on_to_user_id_and_from_user_id"

  create_table "feed_entry_activities_archive", :force => true do |t|
    t.column "feed_entry_id",    :integer, :null => false
    t.column "activity_type_id", :integer
    t.column "content_id",       :integer
    t.column "content_type",     :string
    t.column "activity_id",      :integer, :null => false
    t.column "position",         :integer
    t.column "from_user_id",     :integer
    t.column "to_user_id",       :integer
  end

  create_table "feedbacks", :force => true do |t|
    t.column "user_id",       :integer
    t.column "complaint",     :text
    t.column "environment",   :text
    t.column "ip",            :string
    t.column "created_at",    :datetime
    t.column "updated_at",    :datetime
    t.column "sent_from",     :string
    t.column "junk",          :boolean,               :default => false
    t.column "created_by_id", :integer,  :limit => 8, :default => 0,     :null => false
    t.column "updated_by_id", :integer,  :limit => 8, :default => 0,     :null => false
  end

  create_table "globalize_countries", :force => true do |t|
    t.column "code",                   :string, :limit => 2
    t.column "english_name",           :string
    t.column "date_format",            :string
    t.column "currency_format",        :string
    t.column "currency_code",          :string, :limit => 3
    t.column "thousands_sep",          :string, :limit => 2
    t.column "decimal_sep",            :string, :limit => 2
    t.column "currency_decimal_sep",   :string, :limit => 2
    t.column "number_grouping_scheme", :string
  end

  add_index "globalize_countries", ["code"], :name => "index_globalize_countries_on_code"

  create_table "globalize_languages", :force => true do |t|
    t.column "iso_639_1",             :string,  :limit => 2
    t.column "iso_639_2",             :string,  :limit => 3
    t.column "iso_639_3",             :string,  :limit => 3
    t.column "rfc_3066",              :string
    t.column "english_name",          :string
    t.column "english_name_locale",   :string
    t.column "english_name_modifier", :string
    t.column "native_name",           :string
    t.column "native_name_locale",    :string
    t.column "native_name_modifier",  :string
    t.column "macro_language",        :boolean
    t.column "direction",             :string
    t.column "pluralization",         :string
    t.column "scope",                 :string,  :limit => 1
  end

  add_index "globalize_languages", ["iso_639_1"], :name => "index_globalize_languages_on_iso_639_1"
  add_index "globalize_languages", ["iso_639_2"], :name => "index_globalize_languages_on_iso_639_2"
  add_index "globalize_languages", ["iso_639_3"], :name => "index_globalize_languages_on_iso_639_3"
  add_index "globalize_languages", ["rfc_3066"], :name => "index_globalize_languages_on_rfc_3066"

  create_table "globalize_translations", :force => true do |t|
    t.column "type",                :string
    t.column "tr_key",              :string
    t.column "table_name",          :string
    t.column "item_id",             :integer
    t.column "facet",               :string
    t.column "language_id",         :integer
    t.column "pluralization_index", :integer
    t.column "text",                :text
    t.column "namespace",           :string
    t.column "created_at",          :datetime
    t.column "updated_at",          :datetime
    t.column "tr_origin",           :string
    t.column "obsolete",            :boolean,  :default => false
    t.column "from_bundle",         :string
    t.column "to_dump",             :boolean,  :default => false, :null => false
  end

  add_index "globalize_translations", ["table_name", "item_id", "language_id"], :name => "globalize_translations_table_name_and_item_and_language"
  add_index "globalize_translations", ["tr_key", "language_id"], :name => "index_globalize_translations_on_tr_key_and_language_id"

  create_table "gt", :force => true do |t|
    t.column "type",                :string
    t.column "tr_key",              :string
    t.column "table_name",          :string
    t.column "item_id",             :integer
    t.column "facet",               :string
    t.column "built_in",            :boolean
    t.column "language_id",         :integer
    t.column "pluralization_index", :integer
    t.column "text",                :text
    t.column "namespace",           :string
  end

  create_table "impact_counters", :force => true do |t|
    t.column "user_id",         :integer,                 :null => false
    t.column "content_id",      :integer,                 :null => false
    t.column "counter_kind_id", :integer
    t.column "total",           :integer,  :default => 0
    t.column "created_at",      :datetime
    t.column "updated_at",      :datetime
    t.column "depth",           :text
    t.column "to_user_id",      :integer
    t.column "referral_type",   :string
  end

  add_index "impact_counters", ["to_user_id"], :name => "index_impact_counters_on_to_user_id"
  add_index "impact_counters", ["user_id"], :name => "index_impact_counters_on_user_id"

  create_table "inbox_items", :force => true do |t|
    t.column "inbox_id",               :integer
    t.column "content_id",             :integer
    t.column "position",               :integer,  :default => 0
    t.column "created_by_id",          :integer
    t.column "created_at",             :datetime
    t.column "updated_at",             :datetime
    t.column "allow_take_to_showcase", :boolean,  :default => true
    t.column "user_id",                :integer
    t.column "original_content_id",    :integer
  end

  add_index "inbox_items", ["content_id"], :name => "index_inbox_items_on_content_id"
  add_index "inbox_items", ["inbox_id", "position"], :name => "index_inbox_items_on_inbox_id_and_position"

  create_table "invite_requests", :force => true do |t|
    t.column "user_id",          :integer
    t.column "circle_id",        :integer
    t.column "wants_to_join_id", :integer
    t.column "created_at",       :datetime
    t.column "updated_at",       :datetime
    t.column "state",            :string,   :default => "pending"
    t.column "invitation_id",    :integer
  end

  add_index "invite_requests", ["wants_to_join_id"], :name => "index_invite_requests_on_wants_to_join_id"

  create_table "invites", :force => true do |t|
    t.column "inviter_id",              :integer
    t.column "user_id",                 :integer
    t.column "user_email",              :string
    t.column "created_at",              :datetime,                                                                     :null => false
    t.column "created_by_id",           :integer,                                               :default => 0,         :null => false
    t.column "invitation",              :text
    t.column "activation_code",         :string,   :limit => 40
    t.column "accepted_at",             :datetime
    t.column "display_name",            :string
    t.column "role_name",               :string
    t.column "circle_id",               :integer
    t.column "updated_at",              :datetime
    t.column "reinvited_at",            :datetime
    t.column "rejected_at",             :datetime
    t.column "price",                   :decimal,                :precision => 10, :scale => 2
    t.column "privacylevel",            :integer,                                               :default => 0,         :null => false
    t.column "free",                    :boolean
    t.column "from_lj",                 :boolean,                                               :default => false
    t.column "state",                   :string,                                                :default => "pending"
    t.column "album_contribution_id",   :integer
    t.column "join_inviter_to_invited", :boolean,                                               :default => false,     :null => false
    t.column "initiated_by_invited",    :boolean,                                               :default => false,     :null => false
    t.column "needs_link_to_download",  :integer
  end

  add_index "invites", ["inviter_id", "circle_id", "accepted_at"], :name => "invite_idx"
  add_index "invites", ["state"], :name => "index_invites_on_state"

  create_table "ip_to_locations", :force => true do |t|
    t.column "from_ip",      :integer, :limit => 8, :null => false
    t.column "to_ip",        :integer, :limit => 8, :null => false
    t.column "country_code", :string,               :null => false
  end

  add_index "ip_to_locations", ["from_ip"], :name => "index_ip_to_locations_on_from_ip"

  create_table "karma_points", :force => true do |t|
    t.column "referrer_id",  :integer
    t.column "content_id",   :integer
    t.column "referral_url", :string
    t.column "created_at",   :datetime
    t.column "updated_at",   :datetime
    t.column "action",       :string
    t.column "referred_id",  :integer
    t.column "points",       :integer,  :default => 0
  end

  add_index "karma_points", ["action"], :name => "karma_action"
  add_index "karma_points", ["referrer_id", "action"], :name => "karma_referrer_action"
  add_index "karma_points", ["referrer_id", "content_id"], :name => "karma_lookup"

  create_table "live_journal_comments", :force => true do |t|
    t.column "account_id",      :integer,                                :null => false
    t.column "comment_id",      :integer
    t.column "parent_id",       :integer
    t.column "journal_item_id", :integer
    t.column "poster_id",       :integer
    t.column "state",           :string,   :limit => 1, :default => "A"
    t.column "user",            :string
    t.column "property",        :string
    t.column "subject",         :string
    t.column "body",            :text
    t.column "posted_at",       :datetime
    t.column "created_at",      :datetime
    t.column "updated_at",      :datetime
  end

  add_index "live_journal_comments", ["account_id", "comment_id"], :name => "lj_comment_account_and_comment"
  add_index "live_journal_comments", ["account_id", "posted_at"], :name => "lj_account_and_post_date"

  create_table "live_journal_entries", :force => true do |t|
    t.column "account_id",      :integer,                                 :null => false
    t.column "anum",            :integer
    t.column "journal_item_id", :integer
    t.column "backdated",       :boolean
    t.column "preformatted",    :boolean
    t.column "event",           :text
    t.column "subject",         :string
    t.column "music",           :string
    t.column "location",        :string
    t.column "security",        :string
    t.column "screening",       :string
    t.column "posted_at",       :datetime
    t.column "created_at",      :datetime
    t.column "updated_at",      :datetime
    t.column "content_id",      :integer,                  :default => 0, :null => false
    t.column "comments",        :integer,                  :default => 0, :null => false
    t.column "taglist",         :string,   :limit => 2048
    t.column "event_cut",       :text
    t.column "event_formatted", :text
  end

  add_index "live_journal_entries", ["account_id", "journal_item_id"], :name => "lj_entries_account_and_item"
  add_index "live_journal_entries", ["content_id", "posted_at"], :name => "index_live_journal_entries_on_content_id_and_posted_at"

  create_table "live_journal_friends", :force => true do |t|
    t.column "account_id", :integer,                                     :null => false
    t.column "last_sync",  :datetime, :default => '1970-01-01 00:00:00'
  end

  add_index "live_journal_friends", ["account_id"], :name => "index_live_journal_friends_on_account_id"

  create_table "moderation_events", :force => true do |t|
    t.column "user_id",         :integer
    t.column "type",            :string
    t.column "message",         :text
    t.column "reportable_type", :string
    t.column "reportable_id",   :integer
    t.column "flag_type",       :integer,  :default => 0
    t.column "created_at",      :datetime
    t.column "updated_at",      :datetime
    t.column "reason",          :string
  end

  add_index "moderation_events", ["reason"], :name => "index_reports_on_reason"
  add_index "moderation_events", ["reportable_type", "reportable_id"], :name => "index_reports_on_reportable_type_and_reportable_id"

  create_table "monetary_contributions", :force => true do |t|
    t.column "content_id",                    :integer
    t.column "account_setting_id",            :integer
    t.column "payer_id",                      :integer
    t.column "item_name",                     :string
    t.column "payer_email",                   :string
    t.column "auth_amount",                   :decimal,  :precision => 10, :scale => 2
    t.column "created_at",                    :datetime
    t.column "updated_at",                    :datetime
    t.column "payment_api",                   :string
    t.column "user_kroog_id",                 :integer
    t.column "token",                         :string
    t.column "param_set",                     :text
    t.column "verified",                      :boolean,                                 :default => false
    t.column "invite_id",                     :integer
    t.column "currency_type",                 :string
    t.column "suspect",                       :boolean,                                 :default => true
    t.column "sponsorship_expiration_date",   :datetime
    t.column "last_notified_of_expiration",   :datetime
    t.column "sms_payload_id",                :integer
    t.column "amount_transferred_after_fees", :decimal,  :precision => 10, :scale => 2
    t.column "gross_usd",                     :decimal,  :precision => 11, :scale => 6
    t.column "conversion_rate",               :decimal,  :precision => 11, :scale => 6
    t.column "billable",                      :boolean,                                 :default => true
    t.column "bill_id",                       :integer
    t.column "billable_usd",                  :decimal,  :precision => 11, :scale => 6
  end

  add_index "monetary_contributions", ["account_setting_id"], :name => "index_monetary_contributions_on_account_setting_id"
  add_index "monetary_contributions", ["bill_id"], :name => "index_monetary_contributions_on_bill_id"
  add_index "monetary_contributions", ["content_id"], :name => "index_monetary_contributions_on_announcement_id"
  add_index "monetary_contributions", ["user_kroog_id"], :name => "index_monetary_contributions_on_user_kroog_id"

  create_table "monetary_processor_accounts", :force => true do |t|
    t.column "account_setting_id",    :integer
    t.column "monetary_processor_id", :integer
    t.column "account_identifier",    :string
    t.column "account_type",          :string
    t.column "verified_at",           :datetime
    t.column "created_at",            :datetime
    t.column "updated_at",            :datetime
    t.column "deleted_at",            :datetime
    t.column "type",                  :string
    t.column "external_id",           :string
    t.column "account_level",         :integer
    t.column "state",                 :string
    t.column "reason",                :string
    t.column "created_by_id",         :integer
    t.column "updated_by_id",         :integer
  end

  add_index "monetary_processor_accounts", ["account_setting_id", "verified_at"], :name => "index_mpas_on_account_setting_id_and_verified_at"

  create_table "monetary_processors", :force => true do |t|
    t.column "name",                       :string
    t.column "short_name",                 :string
    t.column "allow_withdrawal",           :boolean,  :default => false
    t.column "allow_donation",             :boolean,  :default => false
    t.column "created_at",                 :datetime
    t.column "updated_at",                 :datetime
    t.column "allow_donations_in_regions", :string,                      :null => false
    t.column "display_order",              :integer,                     :null => false
    t.column "currency",                   :string
  end

  add_index "monetary_processors", ["display_order"], :name => "index_monetary_processors_on_display_order"

  create_table "monetary_transactions", :force => true do |t|
    t.column "receiver_account_setting_id",   :integer
    t.column "sender_account_setting_id",     :integer
    t.column "content_id",                    :integer
    t.column "monetary_processor_account_id", :integer
    t.column "currency_id",                   :integer
    t.column "monetary_processor_id",         :integer
    t.column "monetary_processor_log",        :text
    t.column "gross_amount",                  :decimal,  :precision => 11, :scale => 2, :default => 0.0
    t.column "gross_amount_usd",              :decimal,  :precision => 11, :scale => 2, :default => 0.0
    t.column "monetary_processor_fee_usd",    :decimal,  :precision => 11, :scale => 2, :default => 0.0
    t.column "net_amount_usd",                :decimal,  :precision => 11, :scale => 2, :default => 0.0
    t.column "payable_amount_usd",            :decimal,  :precision => 11, :scale => 2, :default => 0.0
    t.column "handling_fee_usd",              :decimal,  :precision => 11, :scale => 2, :default => 0.0
    t.column "applied_to_balance",            :boolean,                                 :default => false
    t.column "suspicious",                    :boolean,                                 :default => false
    t.column "paid",                          :boolean,                                 :default => false
    t.column "type",                          :string
    t.column "available_at",                  :datetime
    t.column "created_at",                    :datetime
    t.column "updated_at",                    :datetime
    t.column "invite_id",                     :integer
    t.column "sms_payload_id",                :integer
    t.column "conversion_rate",               :decimal,  :precision => 11, :scale => 6
    t.column "sender_email",                  :string
    t.column "item_name",                     :string
    t.column "params",                        :text
    t.column "user_kroog_id",                 :integer
    t.column "token",                         :string
    t.column "billable",                      :boolean,                                 :default => false
    t.column "state",                         :string
    t.column "karma_point_id",                :integer
    t.column "content_type",                  :string
  end

  add_index "monetary_transactions", ["created_at"], :name => "index_monetary_transactions_on_created_at"
  add_index "monetary_transactions", ["receiver_account_setting_id", "content_id"], :name => "mt_r_c"
  add_index "monetary_transactions", ["type"], :name => "mt_t"

  create_table "movable_countries", :force => true do |t|
    t.column "name",          :string
    t.column "currency",      :string
    t.column "force_prefix",  :string
    t.column "tax",           :decimal, :precision => 10, :scale => 2
    t.column "mid",           :integer
    t.column "default_brand", :integer
    t.column "version",       :integer,                                :default => 1
  end

  create_table "movable_numbers", :force => true do |t|
    t.column "number",              :integer
    t.column "cost",                :integer
    t.column "force_prefix",        :string
    t.column "movable_operator_id", :integer
    t.column "formatted_cost",      :string
    t.column "version",             :integer, :default => 1
  end

  add_index "movable_numbers", ["movable_operator_id", "version"], :name => "index_movable_numbers_on_movable_operator_id_and_version"

  create_table "movable_operators", :force => true do |t|
    t.column "name",               :string
    t.column "mid",                :string
    t.column "movable_country_id", :integer
    t.column "version",            :integer, :default => 1
  end

  add_index "movable_operators", ["movable_country_id", "version"], :name => "index_movable_operators_on_movable_country_id_and_version"

  create_table "movable_version", :force => true do |t|
    t.column "current",               :integer,  :default => 1
    t.column "last_updated",          :datetime
    t.column "last_updated_from_ip",  :string
    t.column "last_update_attempted", :datetime
    t.column "last_update_succeeded", :datetime
    t.column "cached_data_digest",    :string
  end

  create_table "music_contest_details", :force => true do |t|
    t.column "content_id",              :integer
    t.column "second_title",            :string
    t.column "second_title_ru",         :string
    t.column "second_title_fr",         :string
    t.column "start_date",              :date
    t.column "end_date",                :date
    t.column "accepts_submissions",     :boolean
    t.column "created_at",              :datetime
    t.column "updated_at",              :datetime
    t.column "terms_and_conditions_id", :integer
  end

  add_index "music_contest_details", ["content_id"], :name => "index_music_contest_details_on_content_id"

  create_table "new_contents", :force => true do |t|
    t.column "content_id", :integer
  end

  add_index "new_contents", ["content_id"], :name => "new_contents_content_id"

  create_table "open_id_associations", :force => true do |t|
    t.column "server_url", :binary
    t.column "handle",     :string
    t.column "secret",     :binary
    t.column "issued",     :integer
    t.column "lifetime",   :integer
    t.column "assoc_type", :string
  end

  create_table "open_id_nonces", :force => true do |t|
    t.column "server_url", :string,  :null => false
    t.column "timestamp",  :integer, :null => false
    t.column "salt",       :string,  :null => false
  end

  create_table "password_resets", :force => true do |t|
    t.column "user_id",          :integer,  :null => false
    t.column "crypted_password", :string,   :null => false
    t.column "created_at",       :datetime
    t.column "updated_at",       :datetime
  end

  create_table "playlist_items", :force => true do |t|
    t.column "playlist_id",   :integer
    t.column "position",      :integer
    t.column "track_id",      :string
    t.column "created_at",    :datetime,                    :null => false
    t.column "created_by_id", :integer,  :default => 0,     :null => false
    t.column "is_playing",    :boolean,  :default => false
    t.column "active",        :boolean,  :default => true
  end

  add_index "playlist_items", ["playlist_id", "is_playing"], :name => "index_playlist_items_on_playlist_id_and_is_playing"
  add_index "playlist_items", ["playlist_id", "position"], :name => "index_playlist_items_on_playlist_id_and_position"

  create_table "playlists", :force => true do |t|
    t.column "user_id",       :integer
    t.column "name",          :string
    t.column "created_at",    :datetime,                :null => false
    t.column "created_by_id", :integer,  :default => 0, :null => false
    t.column "session_id",    :string
  end

  add_index "playlists", ["id", "user_id", "session_id", "name"], :name => "index_playlists_on_id_and_user_id_and_session_id_and_name"
  add_index "playlists", ["user_id", "name"], :name => "index_playlists_on_user_id_and_name"

  create_table "preferences", :force => true do |t|
    t.column "user_id",                                :integer,               :default => 1,         :null => false
    t.column "email_notifications",                    :integer,               :default => 1,         :null => false
    t.column "name_context",                           :string,                :default => "general"
    t.column "email_locale",                           :string,                :default => "en"
    t.column "anonymous_stats",                        :boolean,               :default => false
    t.column "shy_founders_ids",                       :string
    t.column "show_founders_tab",                      :boolean,               :default => true
    t.column "show_founders_module",                   :boolean,               :default => true
    t.column "active_circle_ids",                      :string,                :default => "--- []"
    t.column "show_last_active",                       :boolean,               :default => true
    t.column "getting_around_open",                    :boolean,               :default => true
    t.column "current_locale",                         :string,  :limit => 10
    t.column "email_searchable",                       :boolean,               :default => false
    t.column "show_feed_music",                        :boolean,               :default => true,      :null => false
    t.column "show_feed_pics",                         :boolean,               :default => true,      :null => false
    t.column "show_feed_texts",                        :boolean,               :default => true,      :null => false
    t.column "show_feed_videos",                       :boolean,               :default => true,      :null => false
    t.column "show_feed_people",                       :boolean,               :default => true,      :null => false
    t.column "show_feed_dirs",                         :boolean,               :default => true,      :null => false
    t.column "fb_like_consolidation",                  :string
    t.column "is_auto_follow_fb_friends",              :boolean,               :default => false
    t.column "is_reconnect_with_fb_friends",           :boolean,               :default => false
    t.column "notify_invitations_and_requests",        :boolean,               :default => true
    t.column "notify_joins_interested_circle",         :boolean,               :default => true
    t.column "notify_leaves_interested_circle",        :boolean,               :default => true
    t.column "notify_private_messages",                :boolean,               :default => true
    t.column "kroogi_notify_joins_interested_circle",  :boolean,               :default => true
    t.column "kroogi_notify_leaves_interested_circle", :boolean,               :default => true
  end

  add_index "preferences", ["user_id"], :name => "index_preferences_on_user_id", :unique => true

  create_table "preset_terms_and_conditions", :force => true do |t|
    t.column "title",         :string
    t.column "title_ru",      :string
    t.column "body",          :text
    t.column "body_ru",       :text
    t.column "created_at",    :datetime
    t.column "updated_at",    :datetime
    t.column "created_by_id", :integer
  end

  create_table "profile_datas", :force => true do |t|
    t.column "profile_id", :integer, :default => 1, :null => false
    t.column "user_id",    :integer, :default => 1, :null => false
    t.column "location",   :string
  end

  add_index "profile_datas", ["profile_id"], :name => "index_profile_datas_on_profile_id", :unique => true

  create_table "profile_questions", :force => true do |t|
    t.column "profile_id",          :integer,                :default => 1,                     :null => false
    t.column "user_id",             :integer,                :default => 1,                     :null => false
    t.column "position",            :integer
    t.column "answer",              :text
    t.column "created_by_id",       :integer,                :default => 0,                     :null => false
    t.column "updated_by_id",       :integer,                :default => 0,                     :null => false
    t.column "created_at",          :datetime,               :default => '1970-01-01 00:00:00', :null => false
    t.column "updated_at",          :datetime,               :default => '1970-01-01 00:00:00', :null => false
    t.column "author_id",           :integer,                :default => 0,                     :null => false
    t.column "show_on_kroogi_page", :boolean,                :default => false
    t.column "show_on_profile",     :boolean
    t.column "question_key",        :string,   :limit => 30
    t.column "question",            :string
    t.column "answer_ru",           :text
    t.column "question_ru",         :string
    t.column "answer_fr",           :text
    t.column "question_fr",         :string
  end

  add_index "profile_questions", ["profile_id", "question_key", "position"], :name => "index_profile_questions_on_profile_id_and_question_and_position"

  create_table "profile_types", :force => true do |t|
    t.column "profile_id",      :integer, :default => 1, :null => false
    t.column "user_id",         :integer, :default => 1, :null => false
    t.column "profile_name_id", :integer
  end

  create_table "profiles", :force => true do |t|
    t.column "user_id",          :integer, :default => 1,     :null => false
    t.column "account_type_id",  :integer
    t.column "avatar_id",        :integer
    t.column "userpic_id",       :integer
    t.column "wizard_completed", :boolean, :default => false
    t.column "tagline",          :string
    t.column "tagline_ru",       :string
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id", :unique => true

  create_table "public_answers", :force => true do |t|
    t.column "question_id",   :integer,                     :null => false
    t.column "user_id",       :integer,                     :null => false
    t.column "text",          :text
    t.column "created_at",    :datetime
    t.column "updated_at",    :datetime
    t.column "created_by_id", :integer
    t.column "updated_by_id", :integer
    t.column "avatar_id",     :integer
    t.column "deleted",       :boolean,  :default => false
  end

  add_index "public_answers", ["question_id", "deleted"], :name => "index_public_answers_on_question_id_and_deleted"

  create_table "public_questions", :force => true do |t|
    t.column "user_id",        :integer,                     :null => false
    t.column "text",           :text
    t.column "created_at",     :datetime
    t.column "updated_at",     :datetime
    t.column "text_ru",        :text
    t.column "created_by_id",  :integer
    t.column "updated_by_id",  :integer
    t.column "state",          :string
    t.column "position",       :integer
    t.column "show_on_events", :boolean,  :default => false, :null => false
  end

  add_index "public_questions", ["user_id", "state"], :name => "index_public_questions_on_user_id_and_state"

  create_table "rare_user_settings", :force => true do |t|
    t.column "user_id",                         :integer,                                 :null => false
    t.column "questions_enabled",               :boolean
    t.column "questions_interval",              :integer
    t.column "questions_interval_random_delta", :integer
    t.column "allows_guest_comments",           :boolean
    t.column "fwd_tos_allowed",                 :boolean
    t.column "need_to_show_wizard",             :boolean
    t.column "wall_notes_tab_index",            :integer, :limit => 1
    t.column "questions_kit_id",                :string
    t.column "tps_setup_enabled",               :boolean,              :default => false
  end

  create_table "rating_stats", :force => true do |t|
    t.column "rated_id",     :integer
    t.column "rated_type",   :string
    t.column "rating_count", :integer
    t.column "rating_total", :integer, :limit => 10, :precision => 10, :scale => 0
    t.column "rating_avg",   :decimal,               :precision => 10, :scale => 2
  end

  add_index "rating_stats", ["rated_type", "rated_id"], :name => "index_rating_stats_on_rated_type_and_rated_id"

  create_table "ratings", :force => true do |t|
    t.column "rater_id",   :integer
    t.column "rated_id",   :integer
    t.column "rated_type", :string
    t.column "rating",     :integer, :limit => 10, :precision => 10, :scale => 0
  end

  add_index "ratings", ["rated_type", "rated_id"], :name => "index_ratings_on_rated_type_and_rated_id"
  add_index "ratings", ["rater_id"], :name => "index_ratings_on_rater_id"

  create_table "related_contents", :id => false, :force => true do |t|
    t.column "first_content_id",    :integer,                  :null => false
    t.column "second_content_id",   :integer
    t.column "download_count",      :integer, :default => 0
    t.column "download_percentage", :float,   :default => 0.0
    t.column "relatedness",         :float,   :default => 0.0
  end

  add_index "related_contents", ["first_content_id", "relatedness"], :name => "index_related_contents_on_first_content_id_and_relatedness"

  create_table "related_contents_work_table", :id => false, :force => true do |t|
    t.column "first_content_id",    :integer,                  :null => false
    t.column "second_content_id",   :integer
    t.column "download_count",      :integer, :default => 0
    t.column "download_percentage", :float,   :default => 0.0
    t.column "relatedness",         :float,   :default => 0.0
  end

  add_index "related_contents_work_table", ["first_content_id"], :name => "index_related_contents_work_table_on_first_content_id"

  create_table "relationships", :force => true do |t|
    t.column "user_id",                     :integer,  :default => 0,                     :null => false
    t.column "related_user_id",             :integer,  :default => 0,                     :null => false
    t.column "relationshiptype_id",         :integer,  :default => 0,                     :null => false
    t.column "related_entity_id",           :integer
    t.column "created_at",                  :datetime,                                    :null => false
    t.column "attributebits",               :integer,  :default => 0,                     :null => false
    t.column "expires_at",                  :datetime, :default => '2038-01-01 00:00:00'
    t.column "privacylevel",                :integer,  :default => 0,                     :null => false
    t.column "display_order",               :integer,  :default => 0
    t.column "last_notified_of_expiration", :datetime
    t.column "created_with_fb",             :boolean,  :default => false
  end

  add_index "relationships", ["created_at"], :name => "index_relationships_on_created_at"
  add_index "relationships", ["related_entity_id"], :name => "index_relationships_on_related_entity_id"
  add_index "relationships", ["related_user_id", "relationshiptype_id", "created_at"], :name => "index_relationships_on_relateduserid_typeid_ts"
  add_index "relationships", ["relationshiptype_id", "user_id"], :name => "index_relationships_on_relationshiptype_id_and_user_id"
  add_index "relationships", ["user_id", "relationshiptype_id", "created_at"], :name => "index_relationships_on_userid_typeid_ts"

  create_table "relationshiptypes", :force => true do |t|
    t.column "name",                       :string
    t.column "restricted",                 :integer, :default => 0, :null => false
    t.column "position",                   :integer, :default => 0, :null => false
    t.column "explanation_db_store_id",    :integer
    t.column "explanation_db_store_ru_id", :integer
  end

  create_table "roles", :force => true do |t|
    t.column "name",   :string,  :limit => 30,                :null => false
    t.column "status", :integer,               :default => 1, :null => false
  end

  add_index "roles", ["name"], :name => "index_roles_on_name", :unique => true
  add_index "roles", ["status"], :name => "index_roles_on_status"

  create_table "roles_users", :id => false, :force => true do |t|
    t.column "user_id", :integer, :null => false
    t.column "role_id", :integer, :null => false
  end

  add_index "roles_users", ["user_id", "role_id"], :name => "index_roles_users_on_user_id_and_role_id", :unique => true

  create_table "sms_payloads", :force => true do |t|
    t.column "from_user_id",          :integer
    t.column "to_account_setting_id", :integer
    t.column "payment_for_id",        :integer
    t.column "payment_for_type",      :string
    t.column "created_at",            :datetime
    t.column "updated_at",            :datetime
    t.column "postback_received_at",  :datetime
    t.column "cloned_from_id",        :integer
  end

  add_index "sms_payloads", ["from_user_id"], :name => "index_sms_payloads_on_from_user_id"
  add_index "sms_payloads", ["payment_for_type", "payment_for_id"], :name => "index_sms_payloads_on_payment_for_type_and_payment_for_id"
  add_index "sms_payloads", ["to_account_setting_id"], :name => "index_sms_payloads_on_to_account_setting_id"

  create_table "smscoin_cost_options", :force => true do |t|
    t.column "version_id",       :integer,                                 :default => 0, :null => false
    t.column "country_name",     :string
    t.column "country_name_ru",  :string
    t.column "country_code",     :string
    t.column "local_gross",      :decimal,  :precision => 11, :scale => 2
    t.column "gross_usd",        :decimal,  :precision => 11, :scale => 2
    t.column "net_usd",          :decimal,  :precision => 11, :scale => 2
    t.column "profit",           :decimal,  :precision => 11, :scale => 2
    t.column "currency",         :string
    t.column "provider_code",    :string
    t.column "provider_name",    :string
    t.column "provider_name_ru", :string
    t.column "created_at",       :datetime,                                               :null => false
  end

  add_index "smscoin_cost_options", ["version_id"], :name => "index_smscoin_cost_options_on_version_id"

  create_table "smscoin_transactions", :force => true do |t|
    t.column "recipient_id",         :integer,                    :null => false
    t.column "content_id",           :integer
    t.column "donor_id",             :integer
    t.column "karma_point_id",       :integer
    t.column "state",                :string,                     :null => false
    t.column "return_url",           :string,                     :null => false
    t.column "monetary_donation_id", :integer
    t.column "created_at",           :datetime
    t.column "updated_at",           :datetime
    t.column "cost_option_dump",     :text
    t.column "content_type",         :string
    t.column "download",             :boolean,  :default => true, :null => false
  end

  create_table "smscoin_versions", :force => true do |t|
    t.column "json",               :text
    t.column "created_at",         :datetime,                    :null => false
    t.column "last_checked_at",    :datetime,                    :null => false
    t.column "cached_data_digest", :string,                      :null => false
    t.column "finished",           :boolean,  :default => false, :null => false
  end

  add_index "smscoin_versions", ["finished"], :name => "index_smscoin_versions_on_finished"

  create_table "stats", :force => true do |t|
    t.column "content_id",   :integer
    t.column "user_id",      :integer
    t.column "type",         :string
    t.column "value",        :string
    t.column "ip",           :string
    t.column "created_at",   :datetime
    t.column "updated_at",   :datetime
    t.column "content_type", :string,   :limit => 32
  end

  add_index "stats", ["content_type", "content_id"], :name => "index_stats_on_content_type_and_content_id"
  add_index "stats", ["created_at"], :name => "index_stats_on_created_at"
  add_index "stats", ["type", "content_id"], :name => "index_stats_on_type_and_content_id"
  add_index "stats", ["user_id", "content_id", "content_type", "created_at", "type"], :name => "hit_recently"

  create_table "system_messages_responses", :force => true do |t|
    t.column "type",                :string
    t.column "user_id",             :integer,  :null => false
    t.column "system_message_type", :string,   :null => false
    t.column "created_at",          :datetime
    t.column "updated_at",          :datetime
  end

  create_table "system_messages_show_triggers", :force => true do |t|
    t.column "user_id",             :integer,                 :null => false
    t.column "system_message_type", :string,                  :null => false
    t.column "priority",            :integer,  :default => 0, :null => false
    t.column "created_at",          :datetime
    t.column "updated_at",          :datetime
    t.column "show_at",             :datetime
  end

  create_table "taggings", :force => true do |t|
    t.column "tag_id",        :integer
    t.column "taggable_id",   :integer
    t.column "taggable_type", :string
    t.column "created_at",    :datetime
    t.column "created_by_id", :integer,  :default => 0, :null => false
    t.column "context",       :string
  end

  add_index "taggings", ["taggable_type", "taggable_id"], :name => "index_taggings_on_taggable_type_and_taggable_id"

  create_table "tags", :force => true do |t|
    t.column "name", :string
  end

  create_table "terms_acceptances", :force => true do |t|
    t.column "termable_id",             :integer
    t.column "termable_type",           :string
    t.column "user_id",                 :integer
    t.column "terms_and_conditions_id", :integer
    t.column "created_at",              :datetime
    t.column "updated_at",              :datetime
  end

  create_table "terms_and_conditions", :force => true do |t|
    t.column "require_terms_acceptance", :boolean,  :null => false
    t.column "terms_db_store_id",        :integer
    t.column "terms_db_store_ru_id",     :integer
    t.column "created_at",               :datetime
    t.column "updated_at",               :datetime
    t.column "created_by_id",            :integer
    t.column "updated_by_id",            :integer
  end

  create_table "toggles", :force => true do |t|
    t.column "name",  :string
    t.column "value", :boolean
  end

  add_index "toggles", ["name"], :name => "index_toggles_on_name"

  create_table "tps_content_details", :force => true do |t|
    t.column "content_id",                      :integer,                                                                  :null => false
    t.column "short_description",               :string
    t.column "short_description_ru",            :string
    t.column "end_date",                        :date
    t.column "related_content_id",              :integer
    t.column "participated_count",              :integer,                                               :default => 0
    t.column "goal_amount",                     :decimal,                :precision => 10, :scale => 2, :default => 0.0
    t.column "currently_collected",             :decimal,                :precision => 10, :scale => 2, :default => 0.0
    t.column "created_at",                      :datetime
    t.column "updated_at",                      :datetime
    t.column "stopped",                         :boolean,                                               :default => false, :null => false
    t.column "currency",                        :string,   :limit => 10,                                :default => "usd"
    t.column "specific_amount",                 :boolean,                                               :default => true
    t.column "duration",                        :integer,                                               :default => 0
    t.column "started_at",                      :date
    t.column "offer_goodies",                   :boolean,                                               :default => false
    t.column "goodies_delivery_description",    :text
    t.column "goodies_delivery_description_ru", :text
    t.column "invite_to_interested_circle",     :boolean,                                               :default => true
    t.column "specific_end_date",               :boolean,                                               :default => true
    t.column "slideshow_delays",                :integer,                                               :default => 1
  end

  create_table "tps_goodie_tickets", :force => true do |t|
    t.column "goodie_id",  :integer,                                 :null => false
    t.column "buyer_id",   :integer,                                 :null => false
    t.column "state",      :string,                                  :null => false
    t.column "title",      :string
    t.column "price",      :decimal,  :precision => 10, :scale => 2
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "content_id", :integer,                                 :null => false
  end

  add_index "tps_goodie_tickets", ["buyer_id", "goodie_id", "state"], :name => "index_tps_goodie_tickets_on_buyer_id_and_goodie_id_and_state"

  create_table "tps_goodies", :force => true do |t|
    t.column "content_id",            :integer,                                                    :null => false
    t.column "identifier",            :integer,                                                    :null => false
    t.column "title",                 :string
    t.column "title_ru",              :string
    t.column "price",                 :decimal,  :precision => 10, :scale => 2, :default => 0.0
    t.column "left",                  :integer
    t.column "created_at",            :datetime
    t.column "updated_at",            :datetime
    t.column "donation",              :boolean,                                 :default => false, :null => false
    t.column "downloadable_album_id", :integer
    t.column "needs_document",        :boolean,                                 :default => false, :null => false
    t.column "needs_address",         :boolean,                                 :default => false, :null => false
    t.column "currency",              :string,                                  :default => "usd"
    t.column "delivery_method_group", :string,                                  :default => "A"
  end

  add_index "tps_goodies", ["content_id", "identifier"], :name => "index_tps_goodies_on_content_id_and_identifier", :unique => true

  create_table "tps_participant_info_requests", :force => true do |t|
    t.column "participant_id",      :integer,                     :null => false
    t.column "address_needed",      :boolean,                     :null => false
    t.column "document_needed",     :boolean,                     :null => false
    t.column "answered",            :boolean,  :default => false, :null => false
    t.column "first_name",          :string
    t.column "last_name",           :string
    t.column "document_kind",       :string
    t.column "document_identifier", :string
    t.column "address",             :text
    t.column "created_at",          :datetime
    t.column "updated_at",          :datetime
  end

  add_index "tps_participant_info_requests", ["participant_id"], :name => "index_tps_participant_info_requests_on_participant_id"

  create_table "tps_participants", :force => true do |t|
    t.column "content_id",          :integer,  :null => false
    t.column "user_id",             :integer,  :null => false
    t.column "first_name",          :string
    t.column "last_name",           :string
    t.column "document_kind",       :string
    t.column "document_identifier", :string
    t.column "address",             :text
    t.column "address_missing",     :boolean
    t.column "document_missing",    :boolean
    t.column "state",               :string,   :null => false
    t.column "created_at",          :datetime
    t.column "updated_at",          :datetime
  end

  add_index "tps_participants", ["content_id", "user_id"], :name => "index_tps_participants_on_content_id_and_user_id", :unique => true

  create_table "trackings", :force => true do |t|
    t.column "tracking_user_id",    :integer
    t.column "tracked_item_id",     :integer
    t.column "tracked_item_type",   :string
    t.column "type",                :string
    t.column "created_at",          :datetime
    t.column "updated_at",          :datetime
    t.column "reference_item_id",   :integer
    t.column "reference_item_type", :string
  end

  add_index "trackings", ["tracked_item_type", "tracked_item_id"], :name => "index_trackings_on_tracked_item_type_and_tracked_item_id"
  add_index "trackings", ["tracking_user_id"], :name => "index_trackings_on_tracking_user_id"
  add_index "trackings", ["type"], :name => "index_trackings_on_type"

  create_table "translation_bundles", :force => true do |t|
    t.column "version",    :integer,  :limit => 8,                    :null => false
    t.column "bulk",       :boolean,               :default => false, :null => false
    t.column "created_at", :datetime,                                 :null => false
  end

  add_index "translation_bundles", ["version"], :name => "index_translation_bundles_on_version"

  create_table "user_address_book_items", :force => true do |t|
    t.column "name",    :string
    t.column "email",   :string
    t.column "user_id", :integer
  end

  create_table "user_change_notification_to_realtimes", :force => true do |t|
    t.column "login",      :string,   :default => ""
    t.column "user_id",    :integer
    t.column "deleted",    :boolean,  :default => false
    t.column "token",      :string,   :default => ""
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "user_flashes", :force => true do |t|
    t.column "user_id",    :integer,  :null => false
    t.column "key",        :string,   :null => false
    t.column "data",       :text
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "user_flashes", ["user_id", "key"], :name => "index_user_flashes_on_user_id_and_key"

  create_table "user_kroogs", :force => true do |t|
    t.column "user_id",               :integer,                                                                    :null => false
    t.column "relationshiptype_id",   :integer
    t.column "price",                 :decimal,  :precision => 10, :scale => 2
    t.column "created_at",            :datetime,                                :default => '1970-01-01 00:00:00', :null => false
    t.column "updated_at",            :datetime,                                :default => '1970-01-01 00:00:00', :null => false
    t.column "created_by_id",         :integer,                                 :default => 0,                     :null => false
    t.column "updated_by_id",         :integer,                                 :default => 0,                     :null => false
    t.column "teaser_db_store_id",    :integer
    t.column "name",                  :string
    t.column "open",                  :boolean,                                 :default => true
    t.column "can_request_invite",    :boolean,                                 :default => false
    t.column "name_ru",               :string
    t.column "name_fr",               :string
    t.column "teaser_db_store_ru_id", :integer
  end

  add_index "user_kroogs", ["user_id"], :name => "index_kroogi_settings_on_user_id"

  create_table "users", :force => true do |t|
    t.column "login",                     :string,   :limit => 30,                       :null => false
    t.column "display_name",              :string
    t.column "email",                     :string,                                       :null => false
    t.column "crypted_password",          :string,   :limit => 60,                       :null => false
    t.column "salt",                      :string,   :limit => 60
    t.column "created_at",                :datetime,                                     :null => false
    t.column "updated_at",                :datetime,                                     :null => false
    t.column "created_by_id",             :integer,                :default => 1,        :null => false
    t.column "updated_by_id",             :integer,                :default => 1,        :null => false
    t.column "remember_token",            :string
    t.column "remember_token_expires_at", :datetime
    t.column "activation_code",           :string,   :limit => 40
    t.column "activated_at",              :datetime
    t.column "type",                      :string,   :limit => 32, :default => "User"
    t.column "on_behalf_id",              :integer,                :default => 0,        :null => false
    t.column "state",                     :string,                 :default => "active"
    t.column "state_changed_at",          :datetime
    t.column "display_name_ru",           :string
    t.column "display_name_fr",           :string
    t.column "private",                   :boolean,                :default => false,    :null => false
    t.column "email_verified",            :string
    t.column "popularity",                :float,                  :default => 0.0
    t.column "sid",                       :string
    t.column "gender",                    :string,   :limit => 1
    t.column "language",                  :string,   :limit => 10
    t.column "birthdate",                 :date
    t.column "birthdate_visiblity",       :boolean,                :default => false
    t.column "upload_quota_mb",           :integer
  end

  add_index "users", ["activated_at"], :name => "index_users_on_activated_at"
  add_index "users", ["created_at"], :name => "index_users_on_created_at"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["on_behalf_id"], :name => "index_users_on_on_behalf_id"
  add_index "users", ["popularity"], :name => "index_users_on_popularity"
  add_index "users", ["sid"], :name => "index_users_on_sid"
  add_index "users", ["state", "display_name"], :name => "users_state_and_display_name"
  add_index "users", ["state", "display_name_ru"], :name => "users_state_and_display_name_ru"
  add_index "users", ["state", "login"], :name => "users_state_and_login"

  create_table "venues", :force => true do |t|
    t.column "name",        :string
    t.column "address",     :string
    t.column "city",        :string
    t.column "state",       :string
    t.column "postal_code", :string
    t.column "country",     :string
    t.column "homepage",    :string
    t.column "house_party", :boolean,  :default => false
    t.column "created_at",  :datetime
    t.column "updated_at",  :datetime
  end

  create_table "votes", :force => true do |t|
    t.column "points",        :integer,  :default => 0
    t.column "about",         :string
    t.column "user_id",       :integer
    t.column "type",          :string
    t.column "voteable_type", :string
    t.column "voteable_id",   :integer
    t.column "created_at",    :datetime
    t.column "created_by_id", :integer,  :default => 0, :null => false
  end

  add_index "votes", ["voteable_type", "voteable_id"], :name => "index_votes_on_voteable_type_and_voteable_id"

  create_table "web_money_invoices", :force => true do |t|
    t.column "receiver_account_setting_id", :integer
    t.column "sender_account_setting_id",   :integer
    t.column "source_wmid",                 :string
    t.column "destination_wmid",            :string
    t.column "purse_type",                  :integer
    t.column "days",                        :integer
    t.column "amount",                      :string
    t.column "description",                 :string
    t.column "state",                       :string
    t.column "success",                     :boolean
    t.column "created_at",                  :datetime
    t.column "updated_at",                  :datetime
    t.column "invoice_number",              :string
    t.column "content_id",                  :integer
    t.column "log",                         :text
    t.column "web_money_ticket_id",         :integer
  end

  add_index "web_money_invoices", ["receiver_account_setting_id"], :name => "index_web_money_invoices_on_receiver_account_setting_id"

  create_table "web_money_tickets", :force => true do |t|
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "web_money_transfers", :force => true do |t|
    t.column "receiver_account_setting_id", :string
    t.column "sender_account_setting_id",   :string
    t.column "source_wmid",                 :string
    t.column "destination_wmid",            :string
    t.column "purse_type",                  :integer
    t.column "amount",                      :string
    t.column "success",                     :boolean
    t.column "response",                    :text
    t.column "created_at",                  :datetime
    t.column "updated_at",                  :datetime
    t.column "web_money_ticket_id",         :integer
  end

  create_table "what_you_likes", :force => true do |t|
    t.column "user_id",             :integer
    t.column "related_user_id",     :integer
    t.column "relationshiptype_id", :integer
    t.column "created_at",          :datetime
    t.column "updated_at",          :datetime
  end

end
