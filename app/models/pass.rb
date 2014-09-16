class Pass < ActiveRecord::Base
  extend Enumerize

  belongs_to :rider
  belongs_to :payment_detail
  has_many :tickets, as: :payment

  STATUS_LIST = [:pending, :complete]
  enumerize :status, in: STATUS_LIST

  before_create :initialize_remaining_tickets
  validate :validate_remaining_tickets

  def verify!
    raise "Pass expired" if self.status == "complete" || self.remaining_tickets < 0
  end

  def reserve!(ticket)
    transaction do
      self.remaining_tickets -= 1
      save!
    end
  end

  private
  def initialize_remaining_tickets
    self.remaining_tickets = self.total_tickets
  end

  def validate_remaining_tickets
    errors.add(:out_of_tickets, "No more tickets left on the pass") if self.remaining_tickets < 0
  end
end