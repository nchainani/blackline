class CreateRouteTables < ActiveRecord::Migration
  def change
    create_table :route_templates do |t|
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
      t.float "latitude", null: false
      t.float "longitude", null: false
      t.string "direction", null: false
      t.timestamps
    end

    create_table :route_templates_locations do |t|
      t.integer "route_template_id"
      t.integer "location_id"
    end

    add_foreign_key( :route_templates_locations, :route_templates )
    add_foreign_key( :route_templates_locations, :locations )

    create_table :buses do |t|
      t.integer "capacity"
      t.string "type"
      t.string "owner"
      t.string "registration_number"
      t.timestamps
    end

    create_table :routes do |t|
      t.integer "route_template_id", null: false
      t.integer "bus_id", null: false
      t.datetime "run_date"
      t.string "times"
      t.integer "total_seats"
      t.timestamps
    end

    add_foreign_key( :routes, :route_templates )
    add_foreign_key( :routes, :buses )

  end
end