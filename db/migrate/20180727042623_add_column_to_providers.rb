class AddColumnToProviders < ActiveRecord::Migration[5.2]
  def change
	add_column :providers, :encrypted_provider_password_iv, :string
  end
end
