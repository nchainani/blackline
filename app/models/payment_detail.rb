class PaymentDetail < ActiveRecord::Base
  belongs_to :rider
  has_many :passes
  has_many :tickets, as: :payment
end