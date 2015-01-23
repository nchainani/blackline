class MoveStatusIntoNewTable < ActiveRecord::Migration
  def change
    create_table :route_run_location_updates do |t|
      t.integer :route_run_id, null: false
      t.decimal :lat, precision: 12, scale: 9
      t.decimal :lng, precision: 12, scale: 9
      t.timestamps
    end
    add_foreign_key( :route_run_location_updates, :route_runs )

    remove_column :route_runs, :lat
    remove_column :route_runs, :lng

    # missed adding timestamps originally
    change_table :devices do |t|
      t.timestamps
    end
  end
end
