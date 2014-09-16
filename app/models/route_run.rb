class RouteRun < ActiveRecord::Base
  belongs_to :route
  belongs_to :bus
  delegate :locations, to: :route
  has_many :tickets

  validate :locations_and_times_match, :validate_total_tickets, :validate_remaining_tickets
  before_create :initialize_seats

  def reserve!(ticket)
    transaction do
      self.remaining_tickets -= 1
      save!
    end
  end

  private

  def locations_and_times_match
    if times.to_s.split(",").count != locations.count
      errors.add(:location_and_time_mismatch, "The route has different number of locations and times")
    end
  end

  def initialize_seats
    self.total_tickets ||= bus.capacity
    self.remaining_tickets = self.total_tickets
  end

  def validate_total_tickets
    errors.add(:invalid_total_tickets, "More seats than bus capacity") if (self.total_tickets > bus.capacity)
  end

  def validate_remaining_tickets
    errors.add(:out_of_seats, "No more seats left on this bus") if (self.remaining_tickets < 0)
  end
end