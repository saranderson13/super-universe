class CreateFavoriteOpponents < ActiveRecord::Migration[6.0]
  def change
    create_table :favorite_opponents do |t|
      
      t.integer :user_id
      t.integer :character_id

      t.timestamps
    end
  end
end
