class AddTrackingColumnsToBattles < ActiveRecord::Migration[6.0]
  def change
    add_column :battles, :p_hp, :integer
    add_column :battles, :a_hp, :integer
    add_column :battles, :p_used_pwrmv, :boolean, default: false
    add_column :battles, :a_used_pwrmv, :boolean, default: false
  end
end
