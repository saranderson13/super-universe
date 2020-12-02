class CreateFollowers < ActiveRecord::Migration[6.0]
  def change
    create_table :followers do |t|

      t.references :user, as: :follower
      t.integer :following

      t.timestamps
    end
  end
end
