class Pass < ActiveRecord::Base
  belongs_to :rider
  belongs_to :payment_detail
end