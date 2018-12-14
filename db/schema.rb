# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180922120112) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abouts", force: :cascade do |t|
    t.text     "content"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_abouts_on_course_id", using: :btree
  end

  create_table "alerts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "announcement_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "read",            default: true
    t.index ["announcement_id"], name: "index_alerts_on_announcement_id", using: :btree
    t.index ["user_id"], name: "index_alerts_on_user_id", using: :btree
  end

  create_table "announcements", force: :cascade do |t|
    t.string   "subject"
    t.text     "body"
    t.integer  "sender"
    t.string   "sender_type"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "email",              default: false
    t.string   "action_type"
    t.string   "action_link"
    t.integer  "action_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "text",               default: false
  end

  create_table "checklist_items", force: :cascade do |t|
    t.string   "description"
    t.integer  "about_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["about_id"], name: "index_checklist_items_on_about_id", using: :btree
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "contact_name"
    t.string   "tel1"
    t.string   "tel2"
    t.string   "tel3"
    t.string   "email"
    t.integer  "course_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "tutor_website"
    t.index ["course_id"], name: "index_contacts_on_course_id", using: :btree
  end

  create_table "course_plans", force: :cascade do |t|
    t.decimal  "price",                    default: "0.0"
    t.string   "plan_name"
    t.string   "refund_policy",            default: "No Refunds"
    t.integer  "course_id"
    t.integer  "capacity"
    t.text     "description"
    t.boolean  "trade_by_barter",          default: false
    t.string   "display_pic_file_name"
    t.string   "display_pic_content_type"
    t.integer  "display_pic_file_size"
    t.datetime "display_pic_updated_at"
    t.date     "start_date"
    t.date     "end_date"
    t.text     "week_days",                default: [],           array: true
    t.string   "status",                   default: "Open"
    t.string   "auto_reset",               default: "Never"
    t.string   "slug"
    t.index ["slug"], name: "index_course_plans_on_slug", unique: true, using: :btree
  end

  create_table "course_promotions", force: :cascade do |t|
    t.float    "price",              default: 7500.0
    t.integer  "course_id"
    t.integer  "organizer_order_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["course_id"], name: "index_course_promotions_on_course_id", using: :btree
    t.index ["organizer_order_id"], name: "index_course_promotions_on_organizer_order_id", using: :btree
  end

  create_table "course_requests", force: :cascade do |t|
    t.string   "sender_trade_courses"
    t.string   "sender_email"
    t.string   "sender_phone"
    t.text     "additional_info"
    t.boolean  "owner_read",           default: false
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "reciever_id"
    t.string   "status",               default: "new"
    t.index ["course_id"], name: "index_course_requests_on_course_id", using: :btree
    t.index ["user_id"], name: "index_course_requests_on_user_id", using: :btree
  end

  create_table "course_rewards", force: :cascade do |t|
    t.string   "name"
    t.string   "acronym"
    t.text     "description"
    t.integer  "about_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["about_id"], name: "index_course_rewards_on_about_id", using: :btree
  end

  create_table "course_tutors", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "tutor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_tutors_on_course_id", using: :btree
    t.index ["tutor_id"], name: "index_course_tutors_on_tutor_id", using: :btree
  end

  create_table "courses", force: :cascade do |t|
    t.string   "title"
    t.string   "tutor"
    t.boolean  "saed"
    t.integer  "user_id"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.string   "display_pic_file_name"
    t.string   "display_pic_content_type"
    t.integer  "display_pic_file_size"
    t.datetime "display_pic_updated_at"
    t.string   "course_state"
    t.string   "attended_by"
    t.boolean  "online"
    t.string   "locality"
    t.string   "schedule_style"
    t.integer  "organizer_id"
    t.string   "local_area"
    t.integer  "completeness"
    t.string   "category"
    t.integer  "homepage_slider_course_id"
    t.boolean  "sold_out",                  default: false
    t.boolean  "featured",                  default: false
    t.float    "longitude"
    t.float    "latitude"
    t.string   "slug"
    t.string   "theme",                     default: "flame_pea_orange"
    t.boolean  "primary",                   default: false
    t.index ["organizer_id"], name: "index_courses_on_organizer_id", using: :btree
    t.index ["slug"], name: "index_courses_on_slug", unique: true, using: :btree
    t.index ["user_id"], name: "index_courses_on_user_id", using: :btree
  end

  create_table "favorite_courses", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "text",       default: true
    t.boolean  "email",      default: true
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "gallery_pics", force: :cascade do |t|
    t.text     "caption"
    t.integer  "course_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.index ["course_id"], name: "index_gallery_pics_on_course_id", using: :btree
  end

  create_table "homepage_slider_courses", force: :cascade do |t|
    t.integer  "course_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "slider_image_file_name"
    t.string   "slider_image_content_type"
    t.integer  "slider_image_file_size"
    t.datetime "slider_image_updated_at"
    t.index ["course_id"], name: "index_homepage_slider_courses_on_course_id", using: :btree
  end

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
    t.index ["user_id"], name: "index_impressions_on_user_id", using: :btree
  end

  create_table "lessons", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_lessons_on_course_id", using: :btree
  end

  create_table "locations", force: :cascade do |t|
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "course_day_id"
    t.integer  "organizer_id"
    t.index ["course_day_id"], name: "index_locations_on_course_day_id", using: :btree
    t.index ["organizer_id"], name: "index_locations_on_organizer_id", using: :btree
  end

  create_table "mailboxer_conversation_opt_outs", force: :cascade do |t|
    t.integer "unsubscriber_id"
    t.string  "unsubscriber_type"
    t.integer "conversation_id"
    t.index ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id", using: :btree
    t.index ["unsubscriber_id", "unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type", using: :btree
  end

  create_table "mailboxer_conversations", force: :cascade do |t|
    t.string   "subject",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "mailboxer_notifications", force: :cascade do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              default: ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                default: false
    t.string   "notification_code"
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "attachment"
    t.datetime "updated_at",                           null: false
    t.datetime "created_at",                           null: false
    t.boolean  "global",               default: false
    t.datetime "expires"
    t.index ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id", using: :btree
    t.index ["notified_object_id", "notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_id_and_type", using: :btree
    t.index ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type", using: :btree
    t.index ["type"], name: "index_mailboxer_notifications_on_type", using: :btree
  end

  create_table "mailboxer_receipts", force: :cascade do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                            null: false
    t.boolean  "is_read",                    default: false
    t.boolean  "trashed",                    default: false
    t.boolean  "deleted",                    default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.boolean  "is_delivered",               default: false
    t.string   "delivery_method"
    t.string   "message_id"
    t.index ["notification_id"], name: "index_mailboxer_receipts_on_notification_id", using: :btree
    t.index ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type", using: :btree
  end

  create_table "org_bank_infos", force: :cascade do |t|
    t.string  "bank_name"
    t.string  "bank_account_number"
    t.string  "bank_account_name"
    t.string  "paystack_id"
    t.string  "paystack_plan"
    t.integer "organizer_id"
  end

  create_table "organizer_credit_bals", force: :cascade do |t|
    t.integer  "email_regular"
    t.integer  "email_bonus"
    t.integer  "organizer_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "text_regular"
    t.integer  "text_bonus"
    t.index ["organizer_id"], name: "index_organizer_credit_bals_on_organizer_id", using: :btree
  end

  create_table "organizer_credit_orders", force: :cascade do |t|
    t.float    "email_price",        default: 7.5
    t.integer  "organizer_order_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "email_quantity",     default: 0
    t.float    "text_price",         default: 11.99
    t.integer  "text_quantity",      default: 0
    t.index ["organizer_order_id"], name: "index_organizer_credit_orders_on_organizer_order_id", using: :btree
  end

  create_table "organizer_orders", force: :cascade do |t|
    t.float    "total"
    t.string   "status",                default: "awaiting payment"
    t.integer  "organizer_id"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "order_number"
    t.string   "transaction_reference"
    t.string   "access_code"
    t.string   "authorization_url"
    t.integer  "transaction_id"
    t.index ["organizer_id"], name: "index_organizer_orders_on_organizer_id", using: :btree
  end

  create_table "organizers", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "location_id"
    t.string   "website"
    t.string   "slug"
    t.integer  "paystack_id"
    t.text     "about"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.index ["slug"], name: "index_organizers_on_slug", unique: true, using: :btree
    t.index ["user_id"], name: "index_organizers_on_user_id", using: :btree
  end

  create_table "qualifications", force: :cascade do |t|
    t.string   "description"
    t.integer  "tutor_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["tutor_id"], name: "index_qualifications_on_tutor_id", using: :btree
  end

  create_table "reports", force: :cascade do |t|
    t.string   "reason"
    t.text     "explanation"
    t.string   "status"
    t.text     "admin_action"
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["course_id"], name: "index_reports_on_course_id", using: :btree
    t.index ["user_id"], name: "index_reports_on_user_id", using: :btree
  end

  create_table "requirements", force: :cascade do |t|
    t.string   "description"
    t.integer  "about_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["about_id"], name: "index_requirements_on_about_id", using: :btree
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "rating"
    t.text     "comment"
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "anonymous"
    t.index ["course_id"], name: "index_reviews_on_course_id", using: :btree
    t.index ["user_id"], name: "index_reviews_on_user_id", using: :btree
  end

  create_table "schedules", force: :cascade do |t|
    t.time     "end_time"
    t.time     "start_time"
    t.string   "week_day"
    t.date     "calender_day"
    t.integer  "course_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["course_id"], name: "index_schedules_on_course_id", using: :btree
  end

  create_table "search_terms", force: :cascade do |t|
    t.string   "term"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "course_count", default: 0
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "social_links", force: :cascade do |t|
    t.integer  "tutor_id"
    t.integer  "contact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "facebook"
    t.string   "linkedin"
    t.string   "twitter"
    t.string   "googleplus"
    t.string   "pintrest"
    t.string   "instagram"
    t.index ["contact_id"], name: "index_social_links_on_contact_id", using: :btree
    t.index ["tutor_id"], name: "index_social_links_on_tutor_id", using: :btree
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "transactions", force: :cascade do |t|
    t.string   "authorisation_url"
    t.string   "access_code"
    t.string   "reference"
    t.string   "status"
    t.integer  "quantity"
    t.integer  "price"
    t.string   "trans_type"
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "buyer_id"
    t.integer  "seller_id"
    t.string   "subscription_code"
    t.string   "email_token"
    t.string   "subscription_status"
    t.index ["course_id"], name: "index_transactions_on_course_id", using: :btree
    t.index ["user_id"], name: "index_transactions_on_user_id", using: :btree
  end

  create_table "tutors", force: :cascade do |t|
    t.string   "name"
    t.text     "bio"
    t.string   "website"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "organizer_id"
    t.string   "job_title"
    t.index ["organizer_id"], name: "index_tutors_on_organizer_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "fname",                  default: "", null: false
    t.string   "lname",                  default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "tel",                    default: "", null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "role"
    t.string   "provider"
    t.string   "uid"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "user_code"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "abouts", "courses"
  add_foreign_key "alerts", "announcements"
  add_foreign_key "alerts", "users"
  add_foreign_key "checklist_items", "abouts"
  add_foreign_key "contacts", "courses"
  add_foreign_key "course_promotions", "courses"
  add_foreign_key "course_promotions", "organizer_orders"
  add_foreign_key "course_requests", "courses"
  add_foreign_key "course_requests", "users"
  add_foreign_key "course_rewards", "abouts"
  add_foreign_key "course_tutors", "courses"
  add_foreign_key "course_tutors", "tutors"
  add_foreign_key "courses", "users"
  add_foreign_key "gallery_pics", "courses"
  add_foreign_key "homepage_slider_courses", "courses"
  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", column: "conversation_id", name: "mb_opt_outs_on_conversations_id"
  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", column: "conversation_id", name: "notifications_on_conversation_id"
  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", column: "notification_id", name: "receipts_on_notification_id"
  add_foreign_key "organizer_credit_bals", "organizers"
  add_foreign_key "organizer_credit_orders", "organizer_orders"
  add_foreign_key "organizer_orders", "organizers"
  add_foreign_key "organizers", "users"
  add_foreign_key "qualifications", "tutors"
  add_foreign_key "reports", "courses"
  add_foreign_key "reports", "users"
  add_foreign_key "requirements", "abouts"
  add_foreign_key "reviews", "courses"
  add_foreign_key "reviews", "users"
  add_foreign_key "social_links", "contacts"
  add_foreign_key "social_links", "tutors"
end
