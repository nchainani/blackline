class PassPlanSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :amount, :currency, :total_tickets
end