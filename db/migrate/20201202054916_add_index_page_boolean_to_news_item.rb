class AddIndexPageBooleanToNewsItem < ActiveRecord::Migration[6.0]
  def change
    add_column :news_items, :indexpage, :boolean, default: true
  end
end
