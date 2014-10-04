class PaymentDetailSerializer < ActiveModel::Serializer
  attributes :id, :active, :last4, :card_type, :token
end
