class RouteRun < ActiveRecord::Base
  belongs_to :route
  belongs_to :bus
  delegate :locations, to: :route
  has_many :tickets

  validate :locations_and_times_match, :validate_total_seats

  before_create :initialize_total_seats

  def reserve(rider, payment, location = nil)
    make_reservation(rider, payment, location)
  end

  def remaining_seats
    self.total_seats - tickets.where("status <> 'canceled'").count
  end

  private

  def make_reservation(rider, payment, location)
    with_lock do
      # this is split across two methods because I doubt in real world
      # create_ticket will first happen and the ticket will be confirmed
      # subsequently in a separate api call
      # clients can use this two step ticket creation to call stripe in between
      ticket = create_ticket(rider, payment, location)
      ticket.confirmed!
    end
  end

  def create_ticket(rider, payment, location)
    payment.with_lock do
      payment.verify!
      ticket = Ticket.create!(rider: rider, payment: payment, location: location, route_run: self)
      payment.reserve!(ticket)
      ticket
    end
  end

  def locations_and_times_match
    if times.to_s.split(",").count != locations.count
      errors.add(:location_and_time_mismatch, "The route has different number of locations and times")
    end
  end

  def initialize_total_seats
    self.total_seats ||= bus.capacity
  end

  def validate_total_seats
    (self.total_seats || 0) <= bus.capacity
  end
end