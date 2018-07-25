class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.string :user
      t.string :browser
      t.string :ip_address
      t.string :controller
      t.string :action
      t.string :params
      t.string :note

      t.timestamps
    end
  end
end
