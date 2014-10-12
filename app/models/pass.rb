class Pass < ActiveRecord::Base
  extend Enumerize

  belongs_to :rider
  belongs_to :payment_detail
  belongs_to :pass_plan
  has_many :tickets, as: :payment

  STATUS_LIST = [:pending, :confirmed, :complete, :canceled]
  enumerize :status, in: STATUS_LIST

  validate :validate_remaining_tickets
  validates_presence_of :total_tickets
  before_create :initialize_remaining_tickets

  def verify!
    raise "Pass expired" if self.status == "complete" || self.remaining_tickets < 0 || (self.expiry_date && self.expiry_date < Time.now)
  end

  def self.create_new_pass!(rider, payment_detail, pass_plan, total_tickets, amount)
    payment_detail.verify!
    create!(rider: rider, payment_detail: payment_detail, pass_plan: pass_plan, total_tickets: total_tickets, purchase_date: Time.now, amount: amount)
  end

  def reserve!(ticket)
    with_lock do
      reload
      self.remaining_tickets -= 1
      self.status = :complete if self.remaining_tickets == 0
      save!
    end
  end

  def charge_card!(object)
    # noop
  end

  def object_canceled!(object)
    with_lock do
      reload
      self.remaining_tickets += 1
      self.status = :confirmed if self.remaining_tickets > 0
      save!
    end    
  end

  def confirmed!
    with_lock do
      charge = payment_detail.charge_card!(self)
      update_attributes!(status: :confirmed, confirmation_id: charge.try(:id))
    end
  end

  def canceled!
    payment_detail.object_canceled!(self)
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