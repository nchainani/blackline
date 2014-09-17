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
    # noop
  end

  private

  def obscure_number
    self.number = self.number.to_s.gsub(/.(?!.{0,3}$)/,'*')
  end
end