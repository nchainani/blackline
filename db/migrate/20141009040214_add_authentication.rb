class AddAuthentication < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :provider
      t.string :uid
      t.integer :rider_id
      t.string :token
      t.string :secret

      t.timestamps
    end
    add_foreign_key( :authentications, :riders )
  end
end
