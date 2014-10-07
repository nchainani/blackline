class PassPlanSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :amount, :currency
end