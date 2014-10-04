class PaymentDetail < ActiveRecord::Base
  belongs_to :rider
  has_many :passes
  has_many :tickets, as: :payment

  before_create :obscure_number

  # not much to verify here unless we get something explicit from Stripe
  def verify!
    raise "Payment details not active anymore" if active == false
  end

  def reserve!(ticket)
    Stripe::Charge.create(
      amount: ticket.amount,
      currency: "usd",
      customer: customer_id
    )
  end

  private

  def obscure_number
    self.last4 = self.last4.to_s.gsub(/.(?!.{0,3}$)/,'*')
  end
end