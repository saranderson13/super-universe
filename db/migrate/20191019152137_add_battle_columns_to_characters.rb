class AddBattleColumnsToCharacters < ActiveRecord::Migration[6.0]
  def change
    add_column :characters, :level, :integer, default: 1
    add_column :characters, :pts_to_next_lvl, :integer, default: 10
    add_column :characters, :lvl_progress, :integer, default: 0
    add_column :characters, :victories, :integer, default: 0
    add_column :characters, :defeats, :integer, default: 0
  end
end
