class CompanyHeadquarters
  include Intersail::RemoteModels::RemoteModel

  remote_attributes :id, :headquarters_name, :company_name, :telephone, :fax, :email, :mobile
end