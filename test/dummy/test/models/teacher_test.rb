require 'test_helper'

class TeacherTest < ActiveSupport::TestCase
  test 'Teacher.all_remote must not be nil' do
    teachers = Teacher.all
    assert_not_nil teachers
  end

  test 'The first teacher in the array must by named DOCENTE UNO' do
    teacher = Teacher.first
    assert_equal 'DOCENTE', teacher.last_name
    assert_equal 'UNO', teacher.first_name
  end

  test 'Teacher.where(\'ENABLED eq 1\') must return at least one teacher' do
    teachers = Teacher.where('ENABLED eq 1')
    assert_not_nil teachers
    assert_operator teachers.count, :>, 0
  end

  test 'Ordering Teachers by last_name and first_name' do
    teachers = Teacher.order('COGNOME_RAGSOC, NOME')
  end
end