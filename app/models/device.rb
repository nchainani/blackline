class Device < ActiveRecord::Base
  extend Enumerize

  belongs_to :rider

  DEVICE_LIST = [:iphone, :ipad]
  enumerize :device, in: DEVICE_LIST
end