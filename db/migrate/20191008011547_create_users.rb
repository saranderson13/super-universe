class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :alias
      t.string :email
      t.string :password_digest
      t.string :profile_pic, default: "default_profile_pic.jpg"
      t.boolean :admin_status, default: false

      t.timestamps
    end
  end
end
