class AddTimezoneToRoute < ActiveRecord::Migration
  def change
    change_table(:routes) do |t|
      t.string :timezone, null: false, default: "Central Time (US & Canada)"
    end
  end
end
