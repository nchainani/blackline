class CreateDeviceTokenModel < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.integer "rider_id", null: false
      t.string "device", null: false
      t.string "device_token", null: false
      t.boolean "active", default: true
    end
    add_foreign_key( :devices, :riders )
  end
end