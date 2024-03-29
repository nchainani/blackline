class RouteRun < ActiveRecord::Base
  include Workflow

  belongs_to :route
  belongs_to :bus
  delegate :locations, to: :route
  has_many :tickets
  has_many :route_run_location_updates

  validate :locations_and_times_match, :validate_total_tickets, :validate_remaining_tickets
  before_create :initialize_seats

  def reserve!(ticket)
    with_lock do
      reload
      self.remaining_tickets -= 1
      save!
    end
  end

  def time_at_location(location)
    times.to_s.split(",")[locations.find_index(location)]
  end

  def ticket_canceled!(ticket)
    with_lock do
      reload
      self.remaining_tickets += 1
      save!
    end    
  end

  workflow do
    state :not_started do
      event :start, transitions_to: :running
    end
    state :running do
      event :start, transitions_to: :running
      event :complete, transitions_to: :complete
    end
    state :complete do
      event :start, transitions_to: :complete
      event :update_location, transitions_to: :complete
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
    errors.add(:invalid_total_tickets, "More seats than bus capacity") if self.total_tickets && (self.total_tickets > bus.capacity)
  end

  def validate_remaining_tickets
    errors.add(:out_of_seats, "No more seats left on this bus") if (self.remaining_tickets < 0)
  end
end