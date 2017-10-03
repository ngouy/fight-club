class CreateCharacterGears < ActiveRecord::Migration[5.0]
  def change
    create_table :character_gears, id: :uuid do |t|
      t.uuid    :gear_id,       null: false
      t.uuid    :character_id,  null: false
      t.integer :capacity_left, null: false
      t.boolean :equiped,       null: false, default: false

      t.timestamps
    end

    add_foreign_key :character_gears, :gears
    add_foreign_key :character_gears, :characters

    add_attachment :character_gears, :icon
  end
end
