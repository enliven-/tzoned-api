class AddCityToTimezones < ActiveRecord::Migration
  def change
    add_column :timezones, :city, :string
    add_index  :timezones, :city, unique: true
  end
end
