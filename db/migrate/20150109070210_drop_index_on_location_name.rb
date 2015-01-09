class DropIndexOnLocationName < ActiveRecord::Migration
  def change
    remove_index :favorite_locations, :name
  end
end
