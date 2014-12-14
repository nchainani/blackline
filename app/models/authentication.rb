class Authentication < ActiveRecord::Base
  belongs_to :rider

  PROVIDERS = [:facebook, :gplus, :blackline]

  validates_inclusion_of :provider, in: PROVIDERS
end