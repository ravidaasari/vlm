class CreateCatalogs < ActiveRecord::Migration[5.2]
  def change
    create_table :catalogs do |t|
      t.string :catalog_name
      t.integer :cpu_min
      t.integer :cpu_max
      t.integer :mem_min
      t.integer :mem_max
      t.integer :disk_size
      t.boolean :swap_disk
      t.string :template_path
      t.string :template_name

      t.timestamps
    end
  end
end
