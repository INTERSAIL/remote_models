class Address
  include Intersail::RemoteModels::RemoteModel

  remote_attributes :street, :zipcode, :city
end