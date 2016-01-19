class CreateTimezones < ActiveRecord::Migration
  def change
    create_table :timezones do |t|
      t.string :name
      t.string :abbr
      t.integer :gmt_difference
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :timezones, :name, unique: true
    add_index :timezones, :abbr, unique: true
  end
end
