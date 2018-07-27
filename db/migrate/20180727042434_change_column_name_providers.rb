class ChangeColumnNameProviders < ActiveRecord::Migration[5.2]
  def change
	rename_column :providers, :provider_password, :encrypted_provider_password
  end
end
