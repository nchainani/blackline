class CreateRiderTables < ActiveRecord::Migration
  def change
    create_table :riders do |t|
      t.string "first_name", null: false
      t.string "last_name", null: false
      t.string "email", null: false
      t.string "password_hash", null: false
      t.boolean "verified", default: false
      t.timestamps
    end

    create_table :payment_details do |t|
      t.integer "rider_id"
      t.string "number" # obscured string with only last 4 digits visible ***********4242
      t.string "token" # think of encrypting this as well
      t.boolean "active", default: true
      t.timestamps
    end
    add_foreign_key( :payment_details, :riders )

    create_table :passes do |t|
      t.integer "rider_id", null: false
      t.integer "payment_detail_id", null: false
      t.integer "total_tickets", default: 0
      t.integer "remaining_tickets", default: 0
      t.datetime "purchase_date", null: false
      t.datetime "expiry_date"
      t.string "status", default: "pending" # goes from pending to complete
      t.timestamps
    end
    add_foreign_key( :passes, :riders )
    add_foreign_key( :passes, :payment_details)

    create_table :tickets do |t|
      t.integer "route_id", null: false
      t.integer "rider_id", null: false
      t.integer "location_id", null: false # do we care? (might need for bought_location and then boarded_location)
      t.integer "payment_id", null: false
      t.string "payment_type", null: false # the payment is 'payment' or 'pass' based on what the user used to purchase this ticket
      t.boolean "boarded", default: false
      t.timestamps
    end
    add_foreign_key( :tickets, :routes )
    add_foreign_key( :tickets, :riders )

    create_table :favorite_locations do |t|
      t.integer "rider_id", null: false
      t.string "name", null: false
      t.string "description"
      t.float "latitude", null: false
      t.float "longitude", null: false
      t.timestamps
    end
    add_foreign_key( :favorite_locations, :riders )
  end
end
