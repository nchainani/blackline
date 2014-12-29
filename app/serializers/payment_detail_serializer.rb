class PaymentDetailSerializer < ActiveModel::Serializer
  attributes :id, :active, :last4, :card_type, :token
  attributes :type

  def type
    'payment_detail'
  end
end
