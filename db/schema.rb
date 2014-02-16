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

ActiveRecord::Schema.define(version: 10) do

  create_table "aoj_submissions", force: true do |t|
    t.integer  "run_id"
    t.string   "user_id"
    t.string   "problem_id"
    t.datetime "submission_date"
    t.string   "status"
    t.string   "language"
    t.integer  "cputime"
    t.integer  "memory"
    t.integer  "code_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "aoj_submissions", ["problem_id"], name: "index_aoj_submissions_on_problem_id"
  add_index "aoj_submissions", ["run_id"], name: "index_aoj_submissions_on_run_id"
  add_index "aoj_submissions", ["submission_date"], name: "index_aoj_submissions_on_submission_date"
  add_index "aoj_submissions", ["user_id"], name: "index_aoj_submissions_on_user_id"

  create_table "contests", force: true do |t|
    t.string   "name"
    t.text     "message",    default: ""
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contests", ["owner_id"], name: "index_contests_on_owner_id"

  create_table "contests_site_problems", force: true do |t|
    t.integer "contest_id"
    t.integer "site_problem_id"
    t.integer "position"
  end

  create_table "contests_users", force: true do |t|
    t.integer  "contest_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contests_users", ["contest_id"], name: "index_contests_users_on_contest_id"
  add_index "contests_users", ["user_id"], name: "index_contests_users_on_user_id"

  create_table "poj_submissions", force: true do |t|
    t.string   "user"
    t.integer  "problem_id"
    t.string   "result"
    t.integer  "memory"
    t.integer  "time"
    t.string   "language"
    t.integer  "length"
    t.datetime "submitted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "poj_submissions", ["problem_id"], name: "index_poj_submissions_on_problem_id"
  add_index "poj_submissions", ["submitted_at"], name: "index_poj_submissions_on_submitted_at"
  add_index "poj_submissions", ["user"], name: "index_poj_submissions_on_user"

  create_table "site_problems", force: true do |t|
    t.string "site",       null: false
    t.string "problem_id", null: false
  end

  add_index "site_problems", ["site", "problem_id"], name: "index_site_problems_on_site_and_problem_id", unique: true

  create_table "standing_caches", force: true do |t|
    t.string   "user",         null: false
    t.string   "problem_type", null: false
    t.string   "problem_id",   null: false
    t.string   "status",       null: false
    t.datetime "submitted_at", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "standing_caches", ["user", "problem_type", "problem_id"], name: "index_standing_caches_on_user_and_problem_type_and_problem_id", unique: true

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "owner_id", null: false
  end

  create_table "twitter_users", id: false, force: true do |t|
    t.string  "uid",     null: false
    t.string  "name",    null: false
    t.string  "token",   null: false
    t.string  "secret",  null: false
    t.integer "user_id", null: false
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "poj_user"
    t.string   "aoj_user"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
