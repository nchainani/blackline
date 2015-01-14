class PaymentDetail < ActiveRecord::Base
  belongs_to :rider
  has_many :passes
  has_many :tickets, as: :payment

  before_create :obscure_number

  attr_encrypted :customer, key: Settings.encryption.customer_id, attribute: 'customer_id'

  # not much to verify here unless we get something explicit from Stripe
  def verify!
    raise "Payment details not active anymore" if active == false
  end

  def reserve!(ticket)
    # reserve is a noop
  end

  def charge_card!(object)
    charge = Stripe::Charge.create(
      amount: object.amount,
      currency: object.currency,
      customer: customer
    )
    charge
  end

  def object_canceled!(object)
    if object.confirmation_id
      charge = Stripe::Charge.retrieve(object.confirmation_id)
      charge.refund
    end
  end

  private

  def obscure_number
    self.last4 = self.last4.to_s.gsub(/.(?!.{0,3}$)/,'*')
  end
end