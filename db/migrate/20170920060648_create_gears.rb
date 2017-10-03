class CreateGears < ActiveRecord::Migration[5.0]
  def change
    types = [
      :Helmet,
      :Shield,
      :Boot,
      :Chest,
      :Weapon,
    ].map{|c| "'#{c}'" }.join(', ')

    execute <<-EOSQL
      CREATE TYPE gear_types AS ENUM (#{types})
    EOSQL

    create_table :gears, id: :uuid do |t|
      t.string  :description,    null: false
      t.string  :name,           null: false, index: { unique: true }
      t.integer :lvl,            null: false
      t.bigint  :price,          null: false
      t.integer :given_max_hp,   null: false
      t.integer :given_speed,    null: false
      t.integer :given_agility,  null: false
      t.integer :given_strength, null: false
      t.integer :max_capacity,   null: false
      t.integer :power

      t.timestamps
    end
    add_column  :gears, :type, :gear_types, null: false
  end
end
