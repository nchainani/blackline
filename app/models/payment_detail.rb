class PaymentDetail < ActiveRecord::Base
  belongs_to :rider
  has_many :passes
end