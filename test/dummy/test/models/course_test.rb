require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def course()
    course = Course.create(name: 'Test', teacher_id: 1)
    Course.expects(from_site: [Person.new(id:1, first_name: 'PAOLINO', last_name: 'PAPERINO')]) if ENV['MOCK']
    course
  end

  def course_with_subscriptions()
    course_with_subscriptions = Course.create(name: 'Test with subs', teacher_id:1)
    course_with_subscriptions.subscriptions.create(student_id: 2)
    course_with_subscriptions.subscriptions.create(student_id: 3)
    Course.expects(from_site: [Person.new(id:2, first_name:'PIPPO', last_name:'PLUTO'), Person.new(id:3, first_name:'MICKEY', last_name:'MOUSE')]) if ENV['MOCK']
    course_with_subscriptions
  end

  test "Course remote_fields for Person must return the corret string" do
    assert_equal 'id,first_name,last_name,birth_date,height,weight,is_admin,address_id', Course.send(:remote_fields_param, Person)
  end

  test "A course with teacher_id = 1 must have one teacher with id=1" do
    c = course

    assert_equal 1, c.teacher.id
  end

  test "A course with teacher_id = 1 must have one teacher named PAOLINO PAPERINO" do
    c = course

    assert_equal 'PAOLINO PAPERINO', "#{c.teacher.first_name} #{c.teacher.last_name}"
  end

  test "A course with two subscriptions must have two students" do
    c = course_with_subscriptions

    assert_equal 2, c.students.count
  end

  test "A course with two subscription student_id = 2,3 must have two students with id=2,3" do
    c = course_with_subscriptions

    assert_equal 'PIPPO', c.students[0].first_name
    assert_equal 'MICKEY', c.students[1].first_name
    assert_equal 2, c.students[0].id
    assert_equal 3, c.students[1].id
  end

  test "Change teacher_id to a course must reset teacher field" do
    c= course
    assert_not_nil c.teacher

    c.teacher_id = 20
    Course.expects(from_site: nil) if ENV['MOCK']
    assert_nil c.teacher

    c.teacher_id = 1
    Course.expects(from_site: [Person.new(id:1, first_name:'PAOLINO', last_name: 'PAPERINO')]) if ENV['MOCK']
    assert_not_nil c.teacher
  end
end
