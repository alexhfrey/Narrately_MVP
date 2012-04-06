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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120406000835) do

  create_table "action_pages", :force => true do |t|
    t.integer   "actionable_id"
    t.string    "actionable_type"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.text      "prompt"
    t.integer   "project_id"
    t.string    "title"
  end

  create_table "action_takens", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
    t.integer  "action_page_id"
    t.integer  "user_id"
  end

  create_table "actions", :force => true do |t|
    t.integer   "user_id"
    t.integer   "project_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "fbcomments", :force => true do |t|
    t.string    "post_id"
    t.string    "action_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.text      "message"
  end

  create_table "identities", :force => true do |t|
    t.string    "name"
    t.string    "email"
    t.string    "password_digest"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "likes", :force => true do |t|
    t.string    "post_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.text      "message"
  end

  create_table "posts", :force => true do |t|
    t.string    "link"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.integer   "user_id"
    t.string    "project_title"
    t.string    "project_image"
    t.text      "description"
    t.string    "file1"
    t.string    "file2"
    t.string    "file3"
    t.string    "purchase_link"
    t.string    "tag1"
    t.integer   "promotion_limit"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.timestamp "output_file_updated_at"
    t.integer   "output_file_file_size"
    t.string    "output_file_file_name"
    t.string    "output_file_content_type"
    t.timestamp "project_image_updated_at"
    t.integer   "project_image_file_size"
    t.string    "project_image_file_name"
    t.string    "project_image_content_type"
    t.boolean   "active"
    t.text      "promotion_description"
    t.string    "promotion_type"
    t.string    "video"
    t.string    "promotion_value"
    t.text      "short_description"
    t.string    "brand_name"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text      "message"
    t.string    "username"
    t.integer   "item"
    t.string    "table"
    t.integer   "month"
    t.integer   "year"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "retweets", :force => true do |t|
    t.string    "post_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.text      "message"
  end

  create_table "shares", :force => true do |t|
    t.integer   "user_id"
    t.integer   "project_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "medium"
    t.string    "referral"
    t.string    "share_id"
    t.text      "twittercode"
  end

  create_table "tweets", :force => true do |t|
    t.string    "link"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string    "name"
    t.string    "email"
    t.integer   "facebook_id"
    t.string    "twitter_handle"
    t.string    "sex"
    t.integer   "age"
    t.string    "referral_campaign"
    t.string    "referral_source"
    t.string    "profile_image"
    t.string    "password"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "provider"
    t.string    "uid"
    t.string    "token"
    t.text      "biography"
    t.string    "category"
    t.string    "facebook_page"
    t.string    "twitter_secret"
    t.string    "twitter_token"
  end

end
