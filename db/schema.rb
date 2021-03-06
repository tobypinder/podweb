# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140327001236) do

  create_table "episodes", force: true do |t|
    t.string   "uid"
    t.string   "title"
    t.string   "author"
    t.string   "link_url"
    t.text     "summary"
    t.text     "content"
    t.string   "image_url"
    t.string   "media_url"
    t.datetime "publish_date"
    t.integer  "podcast_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "podcasts", force: true do |t|
    t.string   "feed_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "raw_feed"
    t.text     "description"
    t.string   "title"
    t.string   "url"
    t.string   "album_art_url"
    t.text     "episodes"
  end

  create_table "podcasts_users", force: true do |t|
    t.integer "user_id"
    t.integer "podcast_id"
  end

  add_index "podcasts_users", ["podcast_id", "user_id"], name: "index_podcasts_users_on_podcast_id_and_user_id", unique: true

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "watched_episodes", force: true do |t|
    t.integer  "user_id"
    t.integer  "episode_id"
    t.integer  "seconds_seen"
    t.boolean  "watched",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "watched_episodes", ["user_id", "episode_id"], name: "index_watched_episodes_on_user_id_and_episode_id", unique: true

end
