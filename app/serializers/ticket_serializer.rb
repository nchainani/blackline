class TicketSerializer < ActiveModel::Serializer
  attributes :id, :route_run_id, :location_id, :status, :rider_id
end
