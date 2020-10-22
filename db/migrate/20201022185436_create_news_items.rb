class CreateNewsItems < ActiveRecord::Migration[6.0]
  def change
    create_table :news_items do |t|
      t.string :title
      t.text :description
      t.boolean :homepage, default: true

      t.timestamps
    end
  end
end
