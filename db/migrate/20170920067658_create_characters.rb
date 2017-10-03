class CreateCharacters < ActiveRecord::Migration[5.0]
  def change
    create_table :characters, id: :uuid do |t|
      t.string  :name, index: { unique: true }, null: false
      t.integer :carac_points_to_spend,         null: false
      t.integer :max_hp,                        null: false
      t.integer :speed,                         null: false
      t.integer :strength,                      null: false
      t.integer :agility,                       null: false
      t.integer :lvl,                           null: false
      t.bigint  :xp,                            null: false
      t.bigint  :gold,                          null: false
      t.bigint  :prev_lvl_xp,                   null: false
      t.bigint  :next_lvl_xp,                   null: false
      t.integer :current_hp,                    null: false
      t.integer :current_max_hp,                null: false
      t.string  :description,                   null: false
      t.boolean :is_stun,                       null: false

      t.timestamps
    end

    add_attachment :characters, :profile_pic

  end
end
