class CreatePowerMoves < ActiveRecord::Migration[6.0]
  def change
    create_table :power_moves do |t|
      t.integer :power_id
      t.integer :move_id

      t.timestamps
    end
  end
end
