class PaymentDetail < ActiveRecord::Base
  belongs_to :rider
  has_many :passes
  has_many :tickets, as: :payment

  # not much to verify here unless we get something explicit from Stripe
  def verify!
    raise "Payment details not active anymore" if active == false
  end

  def reserve!(ticket)
    # noop
  end
end