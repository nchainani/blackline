class PassPlan < ActiveRecord::Base
  has_many :passes
  scope :offer, -> { where(offer: true) }
end