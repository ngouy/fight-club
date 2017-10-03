class CreateArenas < ActiveRecord::Migration[5.0]
  def change
    create_table :arenas, id: :uuid do |t|
      t.uuid :player_1_id
      t.uuid :player_2_id
      t.timestamps
    end

    add_foreign_key    :arenas, :characters, column: :player_1_id
    add_foreign_key    :arenas, :characters, column: :player_2_id
  end
end
