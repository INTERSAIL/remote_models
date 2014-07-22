class Address
  include Intersail::RemoteModels::RemoteModel

  remote_attributes :id, :street, :zipcode, :city
end