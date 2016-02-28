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

ActiveRecord::Schema.define(version: 16) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.integer  "target_id",   null: false
    t.string   "target_type", null: false
    t.integer  "kind",        null: false
    t.text     "parameters"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "activities", ["target_type", "target_id"], name: "index_activities_on_target_type_and_target_id", using: :btree
  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

  create_table "aoj_submissions", force: :cascade do |t|
    t.integer  "run_id",          null: false
    t.string   "user_id",         null: false
    t.string   "problem_id",      null: false
    t.datetime "submission_date", null: false
    t.string   "status",          null: false
    t.string   "language",        null: false
    t.integer  "cputime",         null: false
    t.integer  "memory",          null: false
    t.integer  "code_size",       null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "aoj_submissions", ["problem_id"], name: "index_aoj_submissions_on_problem_id", using: :btree
  add_index "aoj_submissions", ["run_id"], name: "index_aoj_submissions_on_run_id", using: :btree
  add_index "aoj_submissions", ["submission_date"], name: "index_aoj_submissions_on_submission_date", using: :btree

  create_table "codeforces_submissions", force: :cascade do |t|
    t.string   "problem_id",            null: false
    t.string   "handle",                null: false
    t.datetime "submission_time",       null: false
    t.string   "verdict",               null: false
    t.string   "programming_language",  null: false
    t.integer  "time_consumed_millis",  null: false
    t.integer  "memory_consumed_bytes", null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "codeforces_submissions", ["handle"], name: "index_codeforces_submissions_on_handle", using: :btree
  add_index "codeforces_submissions", ["problem_id"], name: "index_codeforces_submissions_on_problem_id", using: :btree
  add_index "codeforces_submissions", ["submission_time"], name: "index_codeforces_submissions_on_submission_time", using: :btree

  create_table "contests", force: :cascade do |t|
    t.string   "name",                    null: false
    t.text     "message",    default: "", null: false
    t.integer  "owner_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "contests", ["owner_id"], name: "index_contests_on_owner_id", using: :btree

  create_table "contests_site_problems", force: :cascade do |t|
    t.integer "contest_id"
    t.integer "site_problem_id"
    t.integer "position"
  end

  create_table "contests_users", force: :cascade do |t|
    t.integer  "contest_id", null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "contests_users", ["contest_id"], name: "index_contests_users_on_contest_id", using: :btree
  add_index "contests_users", ["user_id"], name: "index_contests_users_on_user_id", using: :btree

  create_table "poj_submissions", force: :cascade do |t|
    t.string   "user",         null: false
    t.integer  "problem_id",   null: false
    t.string   "result",       null: false
    t.integer  "memory"
    t.integer  "time"
    t.string   "language",     null: false
    t.integer  "length",       null: false
    t.datetime "submitted_at", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "poj_submissions", ["problem_id"], name: "index_poj_submissions_on_problem_id", using: :btree
  add_index "poj_submissions", ["submitted_at"], name: "index_poj_submissions_on_submitted_at", using: :btree

  create_table "site_problems", force: :cascade do |t|
    t.string "site",       null: false
    t.string "problem_id", null: false
  end

  add_index "site_problems", ["site", "problem_id"], name: "index_site_problems_on_site_and_problem_id", unique: true, using: :btree

  create_table "standing_caches", force: :cascade do |t|
    t.string   "user",         null: false
    t.string   "problem_type", null: false
    t.string   "problem_id",   null: false
    t.string   "status",       null: false
    t.datetime "submitted_at", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "standing_caches", ["user", "problem_type", "problem_id"], name: "index_standing_caches_on_user_and_problem_type_and_problem_id", unique: true, using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "site_problem_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",         limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "site_problem_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",                       null: false
    t.integer "owner_id",                   null: false
    t.integer "taggings_count", default: 0, null: false
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "twitter_users", id: false, force: :cascade do |t|
    t.string  "uid",                     null: false
    t.string  "name",                    null: false
    t.string  "token",                   null: false
    t.string  "secret",                  null: false
    t.integer "user_id",                 null: false
    t.boolean "public",  default: false, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            null: false
    t.string   "poj_user",        null: false
    t.string   "aoj_user",        null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "codeforces_user", null: false
  end

end
