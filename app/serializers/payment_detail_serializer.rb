class PaymentDetailSerializer < ActiveModel::Serializer
  attributes :id, :active, :last4, :card_type
  attributes :type

  def type
    'payment_detail'
  end
end
