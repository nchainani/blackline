class Ticket < ActiveRecord::Base
  extend Enumerize

  belongs_to :route_run
  belongs_to :rider
  belongs_to :location
  belongs_to :payment, polymorphic: true

  STATUS_LIST = [:pending, :confirmed, :boarded, :canceled]
  enumerize :status, in: STATUS_LIST

  def self.create_new_ticket!(route_run, rider, payment, location, amount)
    payment.verify!
    transaction do
      ticket = create!(rider: rider, payment: payment, location: location, route_run: route_run, amount: amount)
      payment.reserve!(ticket)
      route_run.reserve!(ticket)
      ticket
    end
  end

  def confirmed!
    update_attributes!(status: :confirmed)
  end

  def canceled!
    update_attributes!(status: :canceled)
  end
end