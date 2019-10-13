class CreateCharacters < ActiveRecord::Migration[6.0]
  def change
    create_table :characters do |t|
      t.integer :user_id
      t.integer :team_id, default: 0
      t.string :supername
      t.string :secret_identity
      t.string :type
      t.integer :hp
      t.integer :att
      t.integer :def
      t.text :bio

      t.timestamps
    end
  end
end
