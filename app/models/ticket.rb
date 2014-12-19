class Ticket < ActiveRecord::Base
  extend Enumerize

  belongs_to :route_run
  belongs_to :rider
  belongs_to :location
  belongs_to :payment, polymorphic: true

  STATUS_LIST = [:pending, :confirmed, :boarded, :canceled]
  enumerize :status, in: STATUS_LIST

  before_create :assign_uuid

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
    with_lock do
      charge = payment.charge_card!(self)
      update_attributes!(status: :confirmed, confirmation_id: charge.try(:id))
    end
  end

  def canceled!
    payment.object_canceled!(self)
    route_run.ticket_canceled!(self)
    update_attributes!(status: :canceled)
  end

  def assign_uuid
    self.uuid = UUIDTools::UUID.random_create.to_s
  end
end