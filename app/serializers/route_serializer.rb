class RouteSerializer < ActiveModel::Serializer
  attributes :id, :name, :direction, :description, :polyline, :runs, :locations

  def runs
    object.immediate_runs.map do |run|
      RouteRunSerializer.new(run, root: false)
    end
  end

  def locations
    object.locations.map do |location|
      {
        id: location.id,
        lat: location.lat,
        lng: location.lng,
        direction: location.direction,
        name: location.name,
      }
    end
  end
end
