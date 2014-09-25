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

ActiveRecord::Schema.define(version: 20140925233704) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "counties", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.boolean  "standard"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "county_voters", id: false, force: true do |t|
    t.integer "van_id",          limit: 8
    t.string  "state_voter_id"
    t.integer "county_voter_id", limit: 8
    t.string  "county_name"
  end

  add_index "county_voters", ["county_voter_id"], name: "sos_county_id_index", using: :btree

  create_table "voters", force: true do |t|
    t.string   "state_voter_id"
    t.integer  "county_id"
    t.string   "county_name"
    t.integer  "county_voter_id"
    t.date     "av_requested_date"
    t.date     "av_sent_date"
    t.date     "av_returned_date"
    t.date     "ev_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "file_date"
  end

end
