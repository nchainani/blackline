class Pass < ActiveRecord::Base
  extend Enumerize

  belongs_to :rider
  belongs_to :payment_detail
  has_many :tickets, as: :payment

  STATUS_LIST = [:pending, :confirmed, :complete, :canceled]
  enumerize :status, in: STATUS_LIST

  validate :validate_remaining_tickets
  before_create :initialize_remaining_tickets

  def verify!
    raise "Pass expired" if self.status == "complete" || self.remaining_tickets < 0
  end

  def self.create_new_pass!(rider, payment_detail, total_tickets)
    payment_detail.verify!
    create!(rider: rider, payment_detail: payment_detail, total_tickets: total_tickets, purchase_date: Time.now)
  end

  def reserve!(ticket)
    with_lock do
      reload
      self.remaining_tickets -= 1
      self.status = :complete
      save!
    end
  end

  def confirmed!
    update_attributes!(status: :confirmed)
  end

  def canceled!
    update_attributes!(status: :canceled)
  end

  private
  def initialize_remaining_tickets
    self.remaining_tickets = self.total_tickets
  end

  def validate_remaining_tickets
    errors.add(:out_of_tickets, "No more tickets left on the pass") if self.remaining_tickets < 0
  end
end