class CreateRouteTables < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string "name", null: false
      t.string "description"
      t.integer "number"
      t.string "direction", null: false
      t.string "polyline", null: false, length: 1000 # the line on map that describes this route
      t.boolean "active", default: true
      t.timestamps
    end

    create_table :locations do |t|
      t.string "name", null: false
      t.decimal "lat", null: false, precision: 12, scale: 9 # can live with precision: 11 but who cares
      t.decimal "lng", null: false, precision: 12, scale: 9
      t.string "direction", null: false
      t.timestamps
    end
    add_index(:locations, [:lat, :lng], unique: true)
    add_index(:locations, [:lng, :lat], unique: true)

    create_table :locations_routes do |t|
      t.integer "route_id"
      t.integer "location_id"
    end

    add_foreign_key( :locations_routes, :routes )
    add_foreign_key( :locations_routes, :locations )

    create_table :buses do |t|
      t.integer "capacity"
      t.string "bus_type"
      t.string "owner"
      t.string "registration_number"
      t.timestamps
    end

    create_table :route_runs do |t|
      t.integer "route_id", null: false
      t.integer "bus_id", null: false
      t.datetime "run_datetime"
      t.string "times" # this needs to be broken down into its own table (run_datetime alone will not be enough)
      t.integer "total_tickets"
      t.integer "remaining_tickets", default: 0
      t.integer "amount"
      t.string "currency", default: "USD"
      t.timestamps
    end

    add_foreign_key( :route_runs, :routes )
    add_foreign_key( :route_runs, :buses )
    add_index(:route_runs, [:route_id, :run_datetime])

  end
end