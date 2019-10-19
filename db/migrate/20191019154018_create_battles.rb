class CreateBattles < ActiveRecord::Migration[6.0]
  def change
    create_table :battles do |t|
      t.references :protag
      t.references :antag
      t.string :outcome
      t.integer :points, default: 0
      t.integer :turn_count, default: 0
      t.text :log

      t.timestamps
    end
  end
end
