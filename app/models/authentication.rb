class Authentication < ActiveRecord::Base
  extend Enumerize
  belongs_to :rider

  PROVIDERS = [:facebook, :gplus, :blackline]

  enumerize :provider, in: PROVIDERS
end