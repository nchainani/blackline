class Pass < ActiveRecord::Base
  belongs_to :rider
  belongs_to :payment_detail
  has_many :tickets, as: :payment

  STATUS_LIST = ["pending", "complete"]
  validates_inclusion_of :status, in: STATUS_LIST
end