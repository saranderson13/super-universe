class CreateMoves < ActiveRecord::Migration[6.0]
  def change
    create_table :moves do |t|
      t.string :name
      t.string :move_type
      t.integer :base_pts
      t.string :success_descrip
      t.string :fail_descrip
      
      t.timestamps
    end
  end
end
