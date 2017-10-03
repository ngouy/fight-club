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

ActiveRecord::Schema.define(version: 20170920074626) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "arenas", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "player_1_id"
    t.uuid     "player_2_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "character_gears", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "gear_id",                           null: false
    t.uuid     "character_id",                      null: false
    t.integer  "capacity_left",                     null: false
    t.boolean  "equiped",           default: false, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
  end

  create_table "character_stats", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "character_id",                    null: false
    t.integer  "count_crit",          default: 0, null: false
    t.integer  "max_crit",            default: 0, null: false
    t.integer  "max_hit",             default: 0, null: false
    t.integer  "count_hits",          default: 0, null: false
    t.integer  "total_hp_loss",       default: 0, null: false
    t.integer  "total_hp_hitten",     default: 0, null: false
    t.integer  "total_armor_loss",    default: 0, null: false
    t.integer  "total_armor_hitten",  default: 0, null: false
    t.integer  "count_stuns",         default: 0, null: false
    t.integer  "count_get_stuned",    default: 0, null: false
    t.integer  "count_missed",        default: 0, null: false
    t.integer  "total_miss_amount",   default: 0, null: false
    t.integer  "count_dodge",         default: 0, null: false
    t.integer  "total_dodged_amount", default: 0, null: false
    t.integer  "count_win",           default: 0, null: false
    t.integer  "count_loose",         default: 0, null: false
    t.integer  "count_null",          default: 0, null: false
    t.integer  "max_gold",            default: 0, null: false
    t.integer  "max_one_time_gold",   default: 0, null: false
    t.integer  "max_one_time_xp",     default: 0, null: false
    t.integer  "gear_destroyed",      default: 0, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "characters", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name",                     null: false
    t.integer  "carac_points_to_spend",    null: false
    t.integer  "max_hp",                   null: false
    t.integer  "speed",                    null: false
    t.integer  "strength",                 null: false
    t.integer  "agility",                  null: false
    t.integer  "lvl",                      null: false
    t.bigint   "xp",                       null: false
    t.bigint   "gold",                     null: false
    t.bigint   "prev_lvl_xp",              null: false
    t.bigint   "next_lvl_xp",              null: false
    t.integer  "current_hp",               null: false
    t.integer  "current_max_hp",           null: false
    t.string   "description",              null: false
    t.boolean  "is_stun",                  null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "profile_pic_file_name"
    t.string   "profile_pic_content_type"
    t.integer  "profile_pic_file_size"
    t.datetime "profile_pic_updated_at"
    t.index ["name"], name: "index_characters_on_name", unique: true, using: :btree
  end

# Could not dump table "gears" because of following StandardError
#   Unknown type 'gear_types' for column 'type'

  add_foreign_key "arenas", "characters", column: "player_1_id"
  add_foreign_key "arenas", "characters", column: "player_2_id"
  add_foreign_key "character_gears", "characters"
  add_foreign_key "character_gears", "gears"
  add_foreign_key "character_stats", "characters"
end
