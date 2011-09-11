
class SingleSchemaConversion < ActiveRecord::Migration
  def self.up

    # This migration is for development/test env only
    unless ['development','test'].include?(RAILS_ENV)
      puts "WARNING: This migration only modifies development and test environments"
      return
    end

    create_table "account_settings", :force => true do |t|
      t.integer  "user_id",                         :limit => 11
      t.string   "paypal_email",                    :limit => 50
      t.string   "donation_title"
      t.string   "donation_button_label",           :limit => 70,                                :default => "Donate"
      t.text     "donation_request_explanation"
      t.decimal  "donation_amount",                               :precision => 10, :scale => 2
      t.boolean  "show_donation_basket",                                                         :default => false
      t.string   "default_language",                                                             :default => "1819"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "request_status",                                                               :default => "inactive"
      t.string   "webmoney_wmz",                    :limit => 13
      t.string   "webmoney_wme",                    :limit => 13
      t.string   "webmoney_wmr",                    :limit => 13
      t.boolean  "allow_sponsorships",                                                           :default => false
      t.string   "donation_title_ru"
      t.string   "donation_button_label_ru"
      t.text     "donation_request_explanation_ru"
      t.string   "donation_title_fr"
      t.string   "donation_button_label_fr"
      t.text     "donation_request_explanation_fr"
      t.boolean  "notified_of_delay",                                                            :default => false
      t.string   "yandex_scid"
      t.string   "yandex_shopid"
      t.boolean  "allow_yandex",                                                                 :default => false
    end

    add_index "account_settings", ["user_id"], :name => "index_account_settings_on_user_id"

    create_table "accounts", :force => true do |t|
      t.integer  "user_id",          :limit => 11,                                    :null => false
      t.text     "crypted_password",                                                  :null => false
      t.boolean  "verified",                       :default => false
      t.datetime "last_sync",                      :default => '1970-01-01 00:00:00'
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "login"
      t.boolean  "connect_friends",                :default => true
      t.datetime "last_manual_sync"
      t.string   "usejournal"
      t.integer  "friend_circle",    :limit => 11
      t.boolean  "allow_friends"
      t.boolean  "import_mine",                    :default => false
    end

    add_index "accounts", ["user_id"], :name => "index_accounts_on_user_id"

    create_table "activities", :force => true do |t|
      t.integer  "user_id",          :limit => 11,                    :null => false
      t.integer  "activity_type_id", :limit => 4
      t.integer  "status",           :limit => 4,  :default => 1,     :null => false
      t.integer  "db_file_id",       :limit => 11
      t.integer  "from_user_id",     :limit => 11
      t.string   "from_username",    :limit => 30
      t.integer  "content_id",       :limit => 11
      t.string   "content_type",     :limit => 20
      t.datetime "created_at",                                        :null => false
      t.datetime "updated_at",                                        :null => false
      t.boolean  "friendcast",                     :default => false
    end

    add_index "activities", ["user_id", "from_user_id", "activity_type_id", "status"], :name => "activity_idx"

    create_table "activity_counts", :force => true do |t|
      t.integer "user_id",          :limit => 11,                :null => false
      t.integer "activity_type_id", :limit => 4
      t.integer "total",            :limit => 6,  :default => 0, :null => false
      t.integer "unread",           :limit => 6,  :default => 0, :null => false
    end

    add_index "activity_counts", ["user_id", "activity_type_id"], :name => "index_activity_counts_on_user_id_and_activity_count_id"

    create_table "activity_mails", :force => true do |t|
      t.integer  "activity_id", :limit => 11
      t.integer  "user_id",     :limit => 11
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "payload"
    end

    add_index "activity_mails", ["user_id", "created_at"], :name => "index_activity_mails_on_user_id_and_created_at"
    add_index "activity_mails", ["activity_id"], :name => "index_activity_mails_on_activity_id"

    create_table "admin_flashes", :force => true do |t|
      t.string   "message"
      t.datetime "start"
      t.datetime "end"
      t.integer  "priority",   :limit => 11, :default => 0
      t.boolean  "shown",                    :default => true
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "message_ru"
    end

    add_index "admin_flashes", ["shown", "priority"], :name => "index_admin_flashes_on_shown_and_priority"

    create_table "admission_pass_name_list", :force => true do |t|
      t.string "name"
    end

    add_index "admission_pass_name_list", ["name"], :name => "index_admission_pass_name_list_on_name"

    create_table "album_items", :force => true do |t|
      t.integer  "album_id",      :limit => 11
      t.integer  "content_id",    :limit => 11
      t.integer  "position",      :limit => 11, :default => 0, :null => false
      t.integer  "created_by_id", :limit => 11, :default => 0, :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "album_items", ["album_id", "position"], :name => "index_album_items_on_album_id_and_position"

    create_table "announcements", :force => true do |t|
      t.integer  "board_id",                      :limit => 11
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "generate_donor_coupons",                      :default => false
      t.boolean  "require_minimum_to_get_coupon",               :default => true
      t.date     "coupon_expiration_date"
      t.integer  "max_coupons",                   :limit => 11
      t.boolean  "priority",                                    :default => false
    end

    add_index "announcements", ["board_id"], :name => "index_announcements_on_board_id"
    add_index "announcements", ["generate_donor_coupons"], :name => "index_announcements_on_generate_donor_coupons"

    create_table "bdrb_job_queues", :force => true do |t|
      t.binary   "args"
      t.string   "worker_name"
      t.string   "worker_method"
      t.string   "job_key"
      t.integer  "taken",          :limit => 11
      t.integer  "finished",       :limit => 11
      t.integer  "timeout",        :limit => 11
      t.integer  "priority",       :limit => 11
      t.datetime "submitted_at"
      t.datetime "started_at"
      t.datetime "finished_at"
      t.datetime "archived_at"
      t.string   "tag"
      t.string   "submitter_info"
      t.string   "runner_info"
      t.string   "worker_key"
    end

    create_table "blocked_emails", :force => true do |t|
      t.string   "email",                            :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "created_by_id",      :limit => 11
      t.integer  "updated_by_id",      :limit => 11
      t.string   "blocked_because_of"
    end

    add_index "blocked_emails", ["email"], :name => "index_blocked_emails_on_email", :unique => true

    create_table "comments", :force => true do |t|
      t.string   "title",            :limit => 50, :default => ""
      t.datetime "created_at",                                        :null => false
      t.integer  "commentable_id",   :limit => 11, :default => 0,     :null => false
      t.string   "commentable_type", :limit => 15, :default => "",    :null => false
      t.integer  "user_id",          :limit => 11, :default => 0,     :null => false
      t.integer  "comments_count",   :limit => 11, :default => 0,     :null => false
      t.integer  "parent_id",        :limit => 11
      t.integer  "lft",              :limit => 11
      t.integer  "rgt",              :limit => 11
      t.integer  "created_by_id",    :limit => 11, :default => 0,     :null => false
      t.integer  "avatar_id",        :limit => 11
      t.integer  "db_store_id",      :limit => 11
      t.datetime "deleted_at"
      t.integer  "deleted_by",       :limit => 11
      t.boolean  "private",                        :default => false
    end

    add_index "comments", ["user_id"], :name => "fk_comments_user"
    add_index "comments", ["parent_id"], :name => "index_comments_on_parent_id"
    add_index "comments", ["commentable_type", "commentable_id", "deleted_at", "parent_id"], :name => "tuned_comment_index"

    create_table "configurations", :force => true do |t|
      t.string   "config_key"
      t.text     "description"
      t.text     "value"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "configurations", ["config_key"], :name => "index_configurations_on_config_key"

    create_table "content_stats", :force => true do |t|
      t.integer "content_id",      :limit => 11
      t.integer "viewed",          :limit => 11
      t.integer "viewed_today",    :limit => 11
      t.integer "favorited",       :limit => 11
      t.integer "favorited_today", :limit => 11
      t.integer "commented",       :limit => 11
      t.integer "commented_today", :limit => 11
      t.integer "played",          :limit => 11
      t.integer "played_today",    :limit => 11
      t.string  "content_type",    :limit => 20
    end

    add_index "content_stats", ["content_type", "content_id"], :name => "index_content_stats_on_content_type_and_content_id"

    create_table "contents", :force => true do |t|
      t.integer  "user_id",             :limit => 11,                       :null => false
      t.string   "title"
      t.text     "description"
      t.string   "type"
      t.string   "content_type"
      t.string   "filename"
      t.string   "filepath"
      t.integer  "size",                :limit => 11
      t.integer  "parent_id",           :limit => 11
      t.string   "thumbnail"
      t.integer  "width",               :limit => 11
      t.integer  "height",              :limit => 11
      t.datetime "created_at",                                              :null => false
      t.datetime "updated_at",                                              :null => false
      t.boolean  "is_in_gallery",                     :default => false
      t.integer  "db_file_id",          :limit => 11
      t.integer  "foruser_id",          :limit => 11
      t.integer  "cat_id",              :limit => 11, :default => 0,        :null => false
      t.boolean  "is_in_startpage",                   :default => false
      t.boolean  "is_in_myplaylist",                  :default => false
      t.integer  "created_by_id",       :limit => 11, :default => 0,        :null => false
      t.integer  "updated_by_id",       :limit => 11, :default => 0,        :null => false
      t.integer  "author_id",           :limit => 11, :default => 0,        :null => false
      t.string   "artist",              :limit => 80
      t.string   "album",               :limit => 80
      t.integer  "year",                :limit => 4
      t.string   "genre",               :limit => 60
      t.integer  "bitrate",             :limit => 4
      t.string   "chanels",             :limit => 10
      t.integer  "samplerate",          :limit => 4
      t.integer  "length",              :limit => 6
      t.integer  "post_db_store_id",    :limit => 11
      t.string   "language_code",       :limit => 8
      t.string   "owner"
      t.integer  "number_of_tracks",    :limit => 11
      t.string   "title_ru"
      t.text     "description_ru"
      t.string   "title_fr"
      t.text     "description_fr"
      t.integer  "post_db_store_ru_id", :limit => 11
      t.integer  "post_db_store_fr_id", :limit => 11
      t.string   "state",                             :default => "active"
      t.datetime "state_changed_at"
      t.string   "artist_ru"
      t.string   "album_ru"
      t.string   "artist_fr"
      t.string   "album_fr"
      t.boolean  "downloadable",                      :default => false
    end

    add_index "contents", ["type", "created_at"], :name => "index_contents_on_type_and_created_at"
    add_index "contents", ["user_id"], :name => "index_contents_on_user_id"
    add_index "contents", ["state"], :name => "index_contents_on_state"
    add_index "contents", ["parent_id"], :name => "index_contents_on_parent_id"
    add_index "contents", ["type", "downloadable"], :name => "index_contents_on_type_and_downloadable"

    create_table "contents_relationshiptypes", :id => false, :force => true do |t|
      t.integer "content_id",          :limit => 11, :default => 0,  :null => false
      t.integer "relationshiptype_id", :limit => 11, :default => -2, :null => false
    end

    add_index "contents_relationshiptypes", ["content_id", "relationshiptype_id"], :name => "index_contents_relationshiptypes_on_contentid_type"

    create_table "currency_types", :force => true do |t|
      t.integer  "accountable_id",           :limit => 11
      t.string   "accountable_type",                                                      :default => "AccountSetting"
      t.decimal  "roubles",                                :precision => 10, :scale => 2
      t.decimal  "euros",                                  :precision => 10, :scale => 2
      t.decimal  "dollars",                                :precision => 10, :scale => 2
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "sponsorship_prices",                                                    :default => false
      t.boolean  "show_donation_button",                                                  :default => false
      t.string   "donation_button_label"
      t.text     "message_to_donors"
      t.text     "message_to_donors_ru"
      t.string   "donation_button_label_ru"
      t.text     "message_to_donors_fr"
      t.string   "donation_button_label_fr"
    end

    add_index "currency_types", ["accountable_type", "accountable_id"], :name => "index_currency_types_on_accountable_type_and_accountable_id"

    create_table "db_files", :force => true do |t|
      t.binary "data"
    end

    create_table "db_store", :force => true do |t|
      t.text "content"
    end

    create_table "donor_coupons", :force => true do |t|
      t.integer  "user_id",                  :limit => 11
      t.integer  "board_id",                 :limit => 11
      t.integer  "monetary_contribution_id", :limit => 11
      t.string   "coupon_code"
      t.text     "message"
      t.date     "expires_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "access_key"
    end

    add_index "donor_coupons", ["board_id", "monetary_contribution_id"], :name => "relationship_to_contribution", :unique => true
    add_index "donor_coupons", ["user_id"], :name => "index_donor_coupons_on_user_id"

    create_table "event_invites", :force => true do |t|
      t.integer  "user_id",                  :limit => 11
      t.integer  "event_id",                 :limit => 11
      t.string   "event_access_key"
      t.text     "message"
      t.string   "rsvp"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "monetary_contribution_id", :limit => 11
    end

    add_index "event_invites", ["user_id", "event_id"], :name => "index_event_invites_on_user_id_and_event_id"
    add_index "event_invites", ["monetary_contribution_id"], :name => "index_event_invites_on_monetary_contribution_id"

    create_table "events", :force => true do |t|
      t.integer  "max_attendees",    :limit => 11
      t.string   "title"
      t.date     "start_date"
      t.date     "end_date"
      t.text     "description"
      t.integer  "category",         :limit => 2
      t.string   "homepage"
      t.integer  "number_of_guests", :limit => 11
      t.integer  "board_id",         :limit => 11
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "venue_id",         :limit => 11
      t.time     "start_time"
      t.time     "end_time"
    end

    create_table "faqs", :force => true do |t|
      t.string   "question"
      t.text     "answer"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "question_ru"
      t.text     "answer_ru"
    end

    create_table "favorites", :force => true do |t|
      t.integer  "user_id",        :limit => 11
      t.string   "favorable_type", :limit => 30
      t.integer  "favorable_id",   :limit => 11
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "created_by_id",  :limit => 11, :default => 0, :null => false
    end

    add_index "favorites", ["user_id", "created_at"], :name => "index_favorites_on_user_id_and_created_at"

    create_table "featured_items", :force => true do |t|
      t.integer  "item_id",                  :limit => 11
      t.string   "item_type"
      t.boolean  "is_content"
      t.boolean  "is_project"
      t.boolean  "currently_featured"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "editorial_db_store_id",    :limit => 11
      t.integer  "editorial_db_store_ru_id", :limit => 11
      t.string   "synopsis"
      t.string   "synopsis_ru"
    end

    add_index "featured_items", ["currently_featured"], :name => "index_featured_items_on_currently_featured"
    add_index "featured_items", ["editorial_db_store_ru_id"], :name => "index_featured_items_on_db_store_ru_id"
    add_index "featured_items", ["currently_featured", "is_content", "is_project"], :name => "featured_item_idx"

    create_table "feedbacks", :force => true do |t|
      t.integer  "user_id",     :limit => 11
      t.text     "complaint"
      t.text     "environment"
      t.string   "ip"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "globalize_countries", :force => true do |t|
      t.string "code",                   :limit => 2
      t.string "english_name"
      t.string "date_format"
      t.string "currency_format"
      t.string "currency_code",          :limit => 3
      t.string "thousands_sep",          :limit => 2
      t.string "decimal_sep",            :limit => 2
      t.string "currency_decimal_sep",   :limit => 2
      t.string "number_grouping_scheme"
    end

    add_index "globalize_countries", ["code"], :name => "index_globalize_countries_on_code"

    create_table "globalize_languages", :force => true do |t|
      t.string  "iso_639_1",             :limit => 2
      t.string  "iso_639_2",             :limit => 3
      t.string  "iso_639_3",             :limit => 3
      t.string  "rfc_3066"
      t.string  "english_name"
      t.string  "english_name_locale"
      t.string  "english_name_modifier"
      t.string  "native_name"
      t.string  "native_name_locale"
      t.string  "native_name_modifier"
      t.boolean "macro_language"
      t.string  "direction"
      t.string  "pluralization"
      t.string  "scope",                 :limit => 1
    end

    add_index "globalize_languages", ["iso_639_1"], :name => "index_globalize_languages_on_iso_639_1"
    add_index "globalize_languages", ["iso_639_2"], :name => "index_globalize_languages_on_iso_639_2"
    add_index "globalize_languages", ["iso_639_3"], :name => "index_globalize_languages_on_iso_639_3"
    add_index "globalize_languages", ["rfc_3066"], :name => "index_globalize_languages_on_rfc_3066"

    create_table "globalize_translations", :force => true do |t|
      t.string   "type"
      t.string   "tr_key"
      t.string   "table_name"
      t.integer  "item_id",             :limit => 11
      t.string   "facet"
      t.boolean  "built_in",                          :default => true
      t.integer  "language_id",         :limit => 11
      t.integer  "pluralization_index", :limit => 11
      t.text     "text"
      t.string   "namespace"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "tr_origin"
      t.boolean  "obsolete",                          :default => false
    end

    add_index "globalize_translations", ["tr_key", "language_id"], :name => "index_globalize_translations_on_tr_key_and_language_id"
    add_index "globalize_translations", ["table_name", "item_id", "language_id"], :name => "globalize_translations_table_name_and_item_and_language"

    create_table "gt", :force => true do |t|
      t.string  "type"
      t.string  "tr_key"
      t.string  "table_name"
      t.integer "item_id",             :limit => 11
      t.string  "facet"
      t.boolean "built_in"
      t.integer "language_id",         :limit => 11
      t.integer "pluralization_index", :limit => 11
      t.text    "text"
      t.string  "namespace"
    end

    create_table "invite_requests", :force => true do |t|
      t.integer  "user_id",          :limit => 11
      t.integer  "circle_id",        :limit => 11
      t.integer  "wants_to_join_id", :limit => 11
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "state",                          :default => "pending"
      t.integer  "invitation_id",    :limit => 11
    end

    add_index "invite_requests", ["wants_to_join_id"], :name => "index_invite_requests_on_wants_to_join_id"

    create_table "invites", :force => true do |t|
      t.integer  "inviter_id",            :limit => 11
      t.integer  "user_id",               :limit => 11
      t.string   "user_email"
      t.datetime "created_at",                                                                                :null => false
      t.integer  "created_by_id",         :limit => 11,                                :default => 0,         :null => false
      t.text     "invitation"
      t.string   "activation_code",       :limit => 40
      t.datetime "accepted_at"
      t.string   "display_name"
      t.string   "role_name"
      t.integer  "circle_id",             :limit => 11
      t.datetime "updated_at"
      t.datetime "reinvited_at"
      t.datetime "rejected_at"
      t.decimal  "price",                               :precision => 10, :scale => 2
      t.integer  "privacylevel",          :limit => 4,                                 :default => 0,         :null => false
      t.boolean  "free"
      t.boolean  "from_lj",                                                            :default => false
      t.string   "state",                                                              :default => "pending"
      t.integer  "album_contribution_id", :limit => 11
    end

    add_index "invites", ["inviter_id", "circle_id", "accepted_at"], :name => "invite_idx"
    add_index "invites", ["state"], :name => "index_invites_on_state"

    create_table "live_journal_comments", :force => true do |t|
      t.integer  "account_id",      :limit => 11,                  :null => false
      t.integer  "comment_id",      :limit => 11
      t.integer  "parent_id",       :limit => 11
      t.integer  "journal_item_id", :limit => 11
      t.integer  "poster_id",       :limit => 11
      t.string   "state",           :limit => 1,  :default => "A"
      t.string   "user"
      t.string   "property"
      t.string   "subject"
      t.text     "body"
      t.datetime "posted_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "live_journal_comments", ["account_id", "posted_at"], :name => "lj_account_and_post_date"
    add_index "live_journal_comments", ["account_id", "comment_id"], :name => "lj_comment_account_and_comment"

    create_table "live_journal_entries", :force => true do |t|
      t.integer  "account_id",      :limit => 11,                  :null => false
      t.integer  "anum",            :limit => 11
      t.integer  "journal_item_id", :limit => 11
      t.boolean  "backdated"
      t.boolean  "preformatted"
      t.text     "event"
      t.string   "subject"
      t.string   "music"
      t.string   "location"
      t.string   "security"
      t.string   "screening"
      t.datetime "posted_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "content_id",      :limit => 11,   :default => 0, :null => false
      t.integer  "comments",        :limit => 11,   :default => 0, :null => false
      t.string   "taglist",         :limit => 2048
      t.text     "event_cut"
      t.text     "event_formatted"
    end

    add_index "live_journal_entries", ["account_id", "journal_item_id"], :name => "lj_entries_account_and_item"
    add_index "live_journal_entries", ["content_id", "posted_at"], :name => "index_live_journal_entries_on_content_id_and_posted_at"

    create_table "live_journal_friends", :force => true do |t|
      t.integer  "account_id", :limit => 11,                                    :null => false
      t.datetime "last_sync",                :default => '1970-01-01 00:00:00'
    end

    add_index "live_journal_friends", ["account_id"], :name => "index_live_journal_friends_on_account_id"

    create_table "moderation_events", :force => true do |t|
      t.integer  "user_id",         :limit => 11
      t.string   "type"
      t.text     "message"
      t.string   "reportable_type"
      t.integer  "reportable_id",   :limit => 11
      t.integer  "flag_type",       :limit => 11, :default => 0
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "reason"
    end

    add_index "moderation_events", ["reportable_type", "reportable_id"], :name => "index_reports_on_reportable_type_and_reportable_id"
    add_index "moderation_events", ["reason"], :name => "index_reports_on_reason"

    create_table "monetary_contributions", :force => true do |t|
      t.integer  "content_id",                    :limit => 11
      t.integer  "account_setting_id",            :limit => 11
      t.integer  "payer_id",                      :limit => 11
      t.string   "item_name"
      t.string   "payer_email"
      t.decimal  "auth_amount",                                 :precision => 10, :scale => 2
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "payment_api"
      t.integer  "user_kroog_id",                 :limit => 11
      t.string   "token"
      t.text     "param_set"
      t.boolean  "verified",                                                                   :default => false
      t.integer  "invite_id",                     :limit => 11
      t.string   "currency_type"
      t.boolean  "suspect",                                                                    :default => true
      t.datetime "sponsorship_expiration_date"
      t.datetime "last_notified_of_expiration"
      t.integer  "sms_payload_id",                :limit => 11
      t.decimal  "amount_transferred_after_fees",               :precision => 10, :scale => 2
    end

    add_index "monetary_contributions", ["content_id"], :name => "index_monetary_contributions_on_announcement_id"
    add_index "monetary_contributions", ["account_setting_id"], :name => "index_monetary_contributions_on_account_setting_id"
    add_index "monetary_contributions", ["user_kroog_id"], :name => "index_monetary_contributions_on_user_kroog_id"

    create_table "movable_countries", :force => true do |t|
      t.string  "name"
      t.string  "currency"
      t.string  "force_prefix"
      t.decimal "tax",                         :precision => 10, :scale => 2
      t.integer "mid",           :limit => 11
      t.integer "default_brand", :limit => 11
      t.integer "version",       :limit => 11,                                :default => 1
    end

    create_table "movable_numbers", :force => true do |t|
      t.integer "number",               :limit => 11
      t.integer "cost",                 :limit => 11
      t.integer "cost_local",           :limit => 11
      t.string  "force_prefix"
      t.integer "movable_operator_id",  :limit => 11
      t.string  "formatted_cost"
      t.string  "formatted_cost_local"
      t.integer "version",              :limit => 11, :default => 1
    end

    add_index "movable_numbers", ["movable_operator_id", "version"], :name => "index_movable_numbers_on_movable_operator_id_and_version"

    create_table "movable_operators", :force => true do |t|
      t.string  "name"
      t.string  "mid"
      t.integer "movable_country_id", :limit => 11
      t.integer "version",            :limit => 11, :default => 1
    end

    add_index "movable_operators", ["movable_country_id", "version"], :name => "index_movable_operators_on_movable_country_id_and_version"

    create_table "movable_version", :force => true do |t|
      t.integer  "current",               :limit => 11, :default => 1
      t.datetime "last_updated"
      t.string   "last_updated_from_ip"
      t.datetime "last_update_attempted"
      t.datetime "last_update_succeeded"
      t.string   "cached_data_digest"
    end

    create_table "open_id_associations", :force => true do |t|
      t.binary  "server_url"
      t.string  "handle"
      t.binary  "secret"
      t.integer "issued",     :limit => 11
      t.integer "lifetime",   :limit => 11
      t.string  "assoc_type"
    end

    create_table "open_id_nonces", :force => true do |t|
      t.string  "server_url",               :null => false
      t.integer "timestamp",  :limit => 11, :null => false
      t.string  "salt",                     :null => false
    end

    create_table "playlist_items", :force => true do |t|
      t.integer  "playlist_id",   :limit => 11
      t.integer  "position",      :limit => 11
      t.string   "track_id"
      t.datetime "created_at",                                     :null => false
      t.integer  "created_by_id", :limit => 11, :default => 0,     :null => false
      t.boolean  "is_playing",                  :default => false
      t.boolean  "active",                      :default => true
    end

    add_index "playlist_items", ["playlist_id", "position"], :name => "index_playlist_items_on_playlist_id_and_position"
    add_index "playlist_items", ["playlist_id", "is_playing"], :name => "index_playlist_items_on_playlist_id_and_is_playing"

    create_table "playlists", :force => true do |t|
      t.integer  "user_id",       :limit => 11
      t.string   "name"
      t.datetime "created_at",                                 :null => false
      t.integer  "created_by_id", :limit => 11, :default => 0, :null => false
      t.string   "session_id"
    end

    add_index "playlists", ["user_id", "name"], :name => "index_playlists_on_user_id_and_name"
    add_index "playlists", ["id", "user_id", "session_id", "name"], :name => "index_playlists_on_id_and_user_id_and_session_id_and_name"

    create_table "preferences", :force => true do |t|
      t.integer "user_id",              :limit => 11, :default => 1,         :null => false
      t.integer "email_notifications",  :limit => 4,  :default => 2,         :null => false
      t.string  "name_context",                       :default => "general"
      t.string  "email_locale",                       :default => "en"
      t.boolean "anonymous_stats",                    :default => false
      t.string  "shy_founders_ids"
      t.boolean "show_founders_tab",                  :default => true
      t.boolean "show_founders_module",               :default => true
      t.string  "active_circle_ids",                  :default => "--- []"
      t.boolean "show_last_active",                   :default => true
      t.boolean "getting_around_open",                :default => true
    end

    add_index "preferences", ["user_id"], :name => "index_preferences_on_user_id", :unique => true

    create_table "profile_datas", :force => true do |t|
      t.integer "profile_id", :limit => 11, :default => 1, :null => false
      t.integer "user_id",    :limit => 11, :default => 1, :null => false
      t.string  "location"
    end

    add_index "profile_datas", ["profile_id"], :name => "index_profile_datas_on_profile_id", :unique => true

    create_table "profile_questions", :force => true do |t|
      t.integer  "profile_id",          :limit => 11, :default => 1,                     :null => false
      t.integer  "user_id",             :limit => 11, :default => 1,                     :null => false
      t.integer  "position",            :limit => 11
      t.text     "answer"
      t.integer  "created_by_id",       :limit => 11, :default => 0,                     :null => false
      t.integer  "updated_by_id",       :limit => 11, :default => 0,                     :null => false
      t.datetime "created_at",                        :default => '1970-01-01 00:00:00', :null => false
      t.datetime "updated_at",                        :default => '1970-01-01 00:00:00', :null => false
      t.integer  "author_id",           :limit => 11, :default => 0,                     :null => false
      t.boolean  "show_on_kroogi_page",               :default => false
      t.boolean  "show_on_profile"
      t.string   "question_key",        :limit => 30
      t.string   "question"
      t.text     "answer_ru"
      t.string   "question_ru"
      t.text     "answer_fr"
      t.string   "question_fr"
    end

    add_index "profile_questions", ["profile_id", "position"], :name => "index_profile_questions_on_profile_id_and_position"
    add_index "profile_questions", ["profile_id", "question_key"], :name => "index_profile_questions_on_profile_id_and_question_key"

    create_table "profile_types", :force => true do |t|
      t.integer "profile_id",      :limit => 11, :default => 1, :null => false
      t.integer "user_id",         :limit => 11, :default => 1, :null => false
      t.integer "profile_name_id", :limit => 11
    end

    create_table "profiles", :force => true do |t|
      t.integer "user_id",          :limit => 11, :default => 1,     :null => false
      t.integer "account_type_id",  :limit => 11
      t.integer "avatar_id",        :limit => 11
      t.integer "userpic_id",       :limit => 11
      t.boolean "wizard_completed",               :default => false
      t.string  "tagline"
      t.string  "tagline_ru"
    end

    add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id", :unique => true

    create_table "relationships", :force => true do |t|
      t.integer  "user_id",                     :limit => 11, :default => 0,                     :null => false
      t.integer  "related_user_id",             :limit => 11, :default => 0,                     :null => false
      t.integer  "relationshiptype_id",         :limit => 4,  :default => 0,                     :null => false
      t.integer  "related_entity_id",           :limit => 11
      t.datetime "created_at",                                                                   :null => false
      t.integer  "attributebits",               :limit => 11, :default => 0,                     :null => false
      t.datetime "expires_at",                                :default => '2038-01-01 00:00:00'
      t.integer  "privacylevel",                :limit => 4,  :default => 0,                     :null => false
      t.integer  "display_order",               :limit => 11, :default => 0
      t.datetime "last_notified_of_expiration"
    end

    add_index "relationships", ["user_id", "relationshiptype_id", "created_at"], :name => "index_relationships_on_userid_typeid_ts"
    add_index "relationships", ["related_user_id", "relationshiptype_id", "created_at"], :name => "index_relationships_on_relateduserid_typeid_ts"
    add_index "relationships", ["related_entity_id"], :name => "index_relationships_on_related_entity_id"
    add_index "relationships", ["created_at"], :name => "index_relationships_on_created_at"
    add_index "relationships", ["relationshiptype_id", "user_id"], :name => "index_relationships_on_relationshiptype_id_and_user_id"

    create_table "relationshiptypes", :force => true do |t|
      t.string  "name"
      t.integer "restricted",                 :limit => 4,  :default => 0, :null => false
      t.integer "position",                   :limit => 4,  :default => 0, :null => false
      t.integer "explanation_db_store_id",    :limit => 11
      t.integer "explanation_db_store_ru_id", :limit => 11
    end

    create_table "roles", :force => true do |t|
      t.string  "name",   :limit => 30,                :null => false
      t.integer "status", :limit => 4,  :default => 1, :null => false
    end

    add_index "roles", ["name"], :name => "index_roles_on_name", :unique => true
    add_index "roles", ["status"], :name => "index_roles_on_status"

    create_table "roles_users", :id => false, :force => true do |t|
      t.integer "user_id", :limit => 11, :null => false
      t.integer "role_id", :limit => 11, :null => false
    end

    add_index "roles_users", ["user_id", "role_id"], :name => "index_roles_users_on_user_id_and_role_id", :unique => true

    create_table "sms_payloads", :force => true do |t|
      t.integer  "from_user_id",          :limit => 11
      t.integer  "to_account_setting_id", :limit => 11
      t.integer  "payment_for_id",        :limit => 11
      t.string   "payment_for_type"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "postback_received_at"
      t.integer  "cloned_from_id",        :limit => 11
    end

    add_index "sms_payloads", ["from_user_id"], :name => "index_sms_payloads_on_from_user_id"
    add_index "sms_payloads", ["to_account_setting_id"], :name => "index_sms_payloads_on_to_account_setting_id"
    add_index "sms_payloads", ["payment_for_type", "payment_for_id"], :name => "index_sms_payloads_on_payment_for_type_and_payment_for_id"

    create_table "stats", :force => true do |t|
      t.integer  "content_id",   :limit => 11
      t.integer  "user_id",      :limit => 11
      t.string   "type"
      t.string   "value"
      t.string   "ip"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "content_type", :limit => 20
    end

    add_index "stats", ["type", "content_id"], :name => "index_stats_on_type_and_content_id"
    add_index "stats", ["created_at"], :name => "index_stats_on_created_at"
    add_index "stats", ["content_type", "content_id"], :name => "index_stats_on_content_type_and_content_id"
    add_index "stats", ["user_id", "content_id", "content_type", "created_at", "type"], :name => "hit_recently"

    create_table "taggings", :force => true do |t|
      t.integer  "tag_id",        :limit => 11
      t.integer  "taggable_id",   :limit => 11
      t.string   "taggable_type"
      t.datetime "created_at"
      t.integer  "created_by_id", :limit => 11, :default => 0, :null => false
      t.string   "context"
    end

    add_index "taggings", ["taggable_type", "taggable_id"], :name => "index_taggings_on_taggable_type_and_taggable_id"

    create_table "tags", :force => true do |t|
      t.string "name"
    end

    create_table "trackings", :force => true do |t|
      t.integer  "tracking_user_id",    :limit => 11
      t.integer  "tracked_item_id",     :limit => 11
      t.string   "tracked_item_type"
      t.string   "type"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "reference_item_id",   :limit => 11
      t.string   "reference_item_type"
    end

    add_index "trackings", ["tracking_user_id"], :name => "index_trackings_on_tracking_user_id"
    add_index "trackings", ["tracked_item_type", "tracked_item_id"], :name => "index_trackings_on_tracked_item_type_and_tracked_item_id"
    add_index "trackings", ["type"], :name => "index_trackings_on_type"

    create_table "user_kroogs", :force => true do |t|
      t.integer  "user_id",               :limit => 11,                                                   :null => false
      t.integer  "relationshiptype_id",   :limit => 11
      t.decimal  "price",                               :precision => 10, :scale => 2
      t.datetime "created_at",                                                                            :null => false
      t.datetime "updated_at",                                                                            :null => false
      t.integer  "created_by_id",         :limit => 11,                                                   :null => false
      t.integer  "updated_by_id",         :limit => 11,                                                   :null => false
      t.integer  "teaser_db_store_id",    :limit => 11
      t.string   "name"
      t.boolean  "open",                                                               :default => true
      t.boolean  "can_request_invite",                                                 :default => false
      t.string   "name_ru"
      t.string   "name_fr"
      t.integer  "teaser_db_store_ru_id", :limit => 11
    end

    add_index "user_kroogs", ["user_id"], :name => "index_kroogi_settings_on_user_id"

    create_table "users", :force => true do |t|
      t.string   "login",                     :limit => 30,                       :null => false
      t.string   "display_name"
      t.string   "email",                                                         :null => false
      t.string   "crypted_password",          :limit => 60,                       :null => false
      t.string   "salt",                      :limit => 60
      t.datetime "created_at",                                                    :null => false
      t.datetime "updated_at",                                                    :null => false
      t.integer  "created_by_id",             :limit => 11, :default => 1,        :null => false
      t.integer  "updated_by_id",             :limit => 11, :default => 1,        :null => false
      t.string   "remember_token"
      t.datetime "remember_token_expires_at"
      t.string   "activation_code",           :limit => 40
      t.datetime "activated_at"
      t.string   "type",                      :limit => 10, :default => "User",   :null => false
      t.integer  "on_behalf_id",              :limit => 11, :default => 0,        :null => false
      t.string   "state",                                   :default => "active"
      t.datetime "state_changed_at"
      t.string   "display_name_ru"
      t.string   "display_name_fr"
      t.boolean  "is_private",                              :default => false
      t.string   "email_verified"
    end

    add_index "users", ["login"], :name => "index_users_on_login", :unique => true

    create_table "venues", :force => true do |t|
      t.string   "name"
      t.string   "address"
      t.string   "city"
      t.string   "state"
      t.string   "postal_code"
      t.string   "country"
      t.string   "homepage"
      t.boolean  "house_party", :default => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "votes", :force => true do |t|
      t.integer  "points",        :limit => 11, :default => 0
      t.string   "about"
      t.integer  "user_id",       :limit => 11
      t.string   "type"
      t.string   "voteable_type"
      t.integer  "voteable_id",   :limit => 11
      t.datetime "created_at"
      t.integer  "created_by_id", :limit => 11, :default => 0, :null => false
    end

    add_index "votes", ["voteable_type", "voteable_id"], :name => "index_votes_on_voteable_type_and_voteable_id"
  end

  def self.down
    return unless ['development','test'].include?(RAILS_ENV)
  end
end
