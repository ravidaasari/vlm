class RemoveColumnFromInfoblox < ActiveRecord::Migration[5.2]
  def change
  	remove_column :infobloxes, :infoblox_password, :string
  end
end
