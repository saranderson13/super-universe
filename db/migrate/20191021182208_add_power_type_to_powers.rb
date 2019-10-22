class AddPowerTypeToPowers < ActiveRecord::Migration[6.0]
  def change
    add_column :powers, :pwr_type, :string
  end
end
