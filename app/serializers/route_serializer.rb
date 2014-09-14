class RouteSerializer < ActiveModel::Serializer
  attributes :id, :direction, :description, :polyline, :runs

  def runs
    object.immediate_runs.map do |run|
      RouteRunSerializer.new(run, root: false)
    end
  end
end
