class RiderSerializer < BaseSerializer
  attributes :id, :name, :email
  protected_attributes :authentication_token
end