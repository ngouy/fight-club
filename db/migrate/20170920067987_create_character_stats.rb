class CreateCharacterStats < ActiveRecord::Migration[5.0]
  def change
    create_table :character_stats, id: :uuid do |t|
      t.uuid :character_id,           null: false
      t.integer :count_crit,          null: false, default: 0
      t.integer :max_crit,            null: false, default: 0
      t.integer :max_hit,             null: false, default: 0
      t.integer :count_hits,          null: false, default: 0
      t.integer :total_hp_loss,       null: false, default: 0
      t.integer :total_hp_hitten,     null: false, default: 0
      t.integer :total_armor_loss,    null: false, default: 0
      t.integer :total_armor_hitten,  null: false, default: 0
      t.integer :count_stuns,         null: false, default: 0
      t.integer :count_get_stuned,    null: false, default: 0
      t.integer :count_missed,        null: false, default: 0
      t.integer :total_miss_amount,   null: false, default: 0
      t.integer :count_dodge,         null: false, default: 0
      t.integer :total_dodged_amount, null: false, default: 0
      t.integer :count_win,           null: false, default: 0
      t.integer :count_loose,         null: false, default: 0
      t.integer :count_null,          null: false, default: 0
      t.integer :max_gold,            null: false, default: 0
      t.integer :max_one_time_gold,   null: false, default: 0
      t.integer :max_one_time_xp,     null: false, default: 0
      t.integer :gear_destroyed,      null: false, default: 0
      t.timestamps
    end

    add_foreign_key    :character_stats, :characters
  end
end
