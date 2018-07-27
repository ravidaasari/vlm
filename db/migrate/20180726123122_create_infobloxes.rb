class CreateInfobloxes < ActiveRecord::Migration[5.2]
  def change
    create_table :infobloxes do |t|
      t.string :infoblox_url
      t.string :infoblox_username
      t.string :infoblox_password
      t.string :encrypted_infoblox_password
      t.string :encrypted_infoblox_password_iv

      t.timestamps
    end
  end
end
