class CreateProviders < ActiveRecord::Migration[5.2]
  def change
    create_table :providers do |t|
      t.string :provider_name
      t.string :provider_type
      t.string :provider_url
      t.string :provider_user
      t.string :provider_password
      t.string :provider_session

      t.timestamps
    end
  end
end
