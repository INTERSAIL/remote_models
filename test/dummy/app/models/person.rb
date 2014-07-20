class Person
  include Intersail::RemoteModels::RemoteModel
  include Intersail::RemoteModels::RemoteAssociable

  remote_attributes :id, :first_name, :last_name, :birth_date, :height, :weight, :is_admin, :address_id

  has_one_remote :address
end
