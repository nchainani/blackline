class CreateRiderTables < ActiveRecord::Migration
  def change
    create_table :riders do |t|
      # this is in extremely simple world. we will probably want to extend this to support
      # multiple authentication schemes (facebook, twitter etc.) and multiple sessions
      t.string "first_name"
      t.string "last_name"
      t.string "email", null: false
      t.string "password_hash"
      t.boolean "verified", default: false
      t.timestamps
    end

    create_table :payment_details do |t|
      t.integer "rider_id"
      t.string "card_type"
      t.string "last4" # obscured string with only last 4 digits visible ***********4242
      t.string "token" # think of encrypting this as well
      t.string "customer_id" # think of encrypting this as well
      t.boolean "active", default: true
      t.timestamps
    end
    add_foreign_key( :payment_details, :riders )

    create_table :pass_plans do |t|
      t.string "name", null: false
      t.string "description", null: false
      t.integer "amount"
      t.string "currency", default: "USD"
      t.integer "total_tickets", default: 0
      t.boolean "active", default: true
      t.timestamps
    end

    create_table :passes do |t|
      t.integer "rider_id", null: false
      t.integer "payment_detail_id", null: false
      t.integer "total_tickets"
      t.integer "remaining_tickets", default: 0
      t.datetime "purchase_date", null: false
      t.datetime "expiry_date"
      t.integer "amount"
      t.string "currency", default: "USD"
      t.integer "pass_plan_id", null: false
      t.string "status", default: "pending" # goes from pending to complete
      t.string "confirmation_id"
      t.timestamps
    end
    add_foreign_key( :passes, :riders )
    add_foreign_key( :passes, :payment_details)
    add_foreign_key( :passes, :pass_plans )

    create_table :tickets do |t|
      t.integer "route_run_id", null: false
      t.integer "rider_id", null: false
      t.integer "location_id" # do we care? (might need for bought_location and then boarded_location)
      t.integer "payment_id", null: false
      t.string "payment_type", null: false # the payment is 'payment' or 'pass' based on what the user used to purchase this ticket
      t.string "status", default: "pending" # goes from pending, confirmed, boarded, canceled
      t.integer "amount"
      t.string "currency", default: "USD"
      t.string "confirmation_id"
      t.timestamps
    end
    add_foreign_key( :tickets, :route_runs )
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
