class Ticket < ActiveRecord::Base
  belongs_to :route
  belongs_to :rider
  belongs_to :location
  belongs_to :payment, polymorphic: true
end