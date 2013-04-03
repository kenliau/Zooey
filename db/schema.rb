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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130402212040) do

  create_table "documentations", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "permalink"
    t.text     "rendered_content"
  end

  create_table "jobs", :force => true do |t|
    t.integer  "video_id"
    t.integer  "width"
    t.integer  "height"
    t.string   "h264_profile"
    t.string   "h264_quality"
    t.string   "audio_codec"
    t.integer  "audio_bitrate"
    t.integer  "audio_volume"
    t.integer  "mux_rate"
    t.datetime "finished_at"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "jobs", ["video_id"], :name => "index_jobs_on_video_id"

  create_table "progressions", :force => true do |t|
    t.integer  "job_id"
    t.integer  "chunks"
    t.datetime "pull_start_time"
    t.datetime "pull_finish_time"
    t.datetime "chunker_start_time"
    t.datetime "chunker_finish_time"
    t.datetime "tcoder_start_time"
    t.datetime "tcoder_finish_time"
    t.datetime "merger_start_time"
    t.datetime "merger_finish_time"
    t.integer  "chunks_tcoded_so_far"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "chunk_tcode_time",     :default => 0
  end

  add_index "progressions", ["job_id"], :name => "index_progressions_on_job_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "is_admin"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "membership"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "videos", :force => true do |t|
    t.integer  "user_id"
    t.string   "filename"
    t.string   "location"
    t.float    "size"
    t.integer  "frame_distance"
    t.integer  "gop_length"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "duration",       :default => 0
    t.string   "video_name"
  end

  add_index "videos", ["user_id"], :name => "index_videos_on_user_id"

end
