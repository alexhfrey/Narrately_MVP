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

ActiveRecord::Schema.define(:version => 20120207235601) do

  create_table "identities", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.integer  "user_id"
    t.string   "project_title"
    t.text     "description"
    t.string   "file1"
    t.string   "file2"
    t.string   "file3"
    t.string   "purchase_link"
    t.string   "tag1"
    t.integer  "promotion_limit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "output_file_content_type"
    t.datetime "output_file_updated_at"
    t.string   "output_file_file_name"
    t.integer  "output_file_file_size"
    t.string   "project_image_content_type"
    t.datetime "project_image_updated_at"
    t.string   "project_image_file_name"
    t.integer  "project_image_file_size"
    t.boolean  "active"
  end

  create_table "shares", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "medium"
    t.string   "referral"
    t.integer  "share_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "facebook_id"
    t.string   "twitter_handle"
    t.string   "sex"
    t.integer  "age"
    t.string   "referral_campaign"
    t.string   "referral_source"
    t.string   "profile_image"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_content_type"
    t.datetime "avatar_updated_at"
    t.string   "avatar_file_name"
    t.integer  "avatar_file_size"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
  end

end
