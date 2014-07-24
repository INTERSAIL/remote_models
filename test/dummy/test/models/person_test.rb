require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  def person
    p = Person.new(address_id:1)
    p.expects(:from_site).returns([Address.new(id:1)])
    p
  end

  test "Person must have set rattrs" do
    assert_equal [:id, :first_name, :last_name, :birth_date, :height, :weight, :is_admin, :address_id], Person.rattrs
  end

  test "Person with address_id=1 must return an Address with id=1" do
    p = person
    assert_equal 1, p.address.id
  end

  test "Person must respond to all_remote" do
    assert_respond_to Person, :all
  end
end