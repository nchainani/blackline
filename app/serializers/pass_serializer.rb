class PassSerializer < ActiveModel::Serializer
  attributes :id, :status, :rider_id, :total_tickets, :remaining_tickets
end
