class PaymentDetailSerializer < ActiveModel::Serializer
  attributes :id, :active, :number, :token
end
