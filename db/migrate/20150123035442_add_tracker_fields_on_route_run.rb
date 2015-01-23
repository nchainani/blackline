class AddTrackerFieldsOnRouteRun < ActiveRecord::Migration
  def change
    change_table(:route_runs) do |t|
      t.string :workflow_state, null: false, default: "not_started"
      t.decimal :lat, precision: 12, scale: 9 # can live with precision: 11 but who cares
      t.decimal :lng, precision: 12, scale: 9
    end
  end
end