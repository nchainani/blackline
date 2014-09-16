class Ticket < ActiveRecord::Base
  extend Enumerize

  belongs_to :route_run
  belongs_to :rider
  belongs_to :location
  belongs_to :payment, polymorphic: true

  STATUS_LIST = [:pending, :confirmed, :boarded, :canceled]
  enumerize :status, in: STATUS_LIST

  def confirmed!
    update_attributes!(status: :confirmed)
  end

  def canceled!
    update_attributes!(status: :canceled)
  end
end