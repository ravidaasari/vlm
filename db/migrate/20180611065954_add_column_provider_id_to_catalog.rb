class AddColumnProviderIdToCatalog < ActiveRecord::Migration[5.2]
  def change
    add_column :catalogs, :provider_id, :integer
  end
end
