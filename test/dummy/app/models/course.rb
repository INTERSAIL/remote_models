class Course < ActiveRecord::Base
  include Intersail::RemoteModels::RemoteAssociable

  has_one_remote :teacher, name: :person

  has_many :subscriptions
  has_many_remote :students, through: :subscriptions, name: :person
end