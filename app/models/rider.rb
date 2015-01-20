class Rider < ActiveRecord::Base
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable

  has_many :payment_details
  has_many :passes
  has_many :favorite_locations
  has_many :tickets
  has_many :authentications
  has_many :devices

  def offers
    passes.joins(:pass_plan).merge(PassPlan.offer)
  end

  def assign_offers(payment_detail)
    offer_type = Settings.new_user_offer.offer_type
    if new_user? && offer_type
      plan = PassPlan.where(offer_type: offer_type).last
      if plan
        new_pass = Pass.create_new_pass!(self, payment_detail, plan)
        new_pass.confirmed! # This step can ideally be async
      end
    end
  end

  protected
  def password_required?
    false
  end

  private

  def new_user?
    tickets.count == 0 &&
    payment_details.count == 1 &&
    passes.count == 0
  end
end