class PassPlanSerializer < ActiveModel::Serializer
  attributes :id, :name, :amount, :currency
end