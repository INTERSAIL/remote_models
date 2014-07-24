class Teacher
  include Intersail::RemoteModels::RemoteModel

  remote_attributes :id, :first_name, :last_name, :telephone, :fax, :email, :partita_iva, :codice_fiscale, :tariffa_descrizione
end