require_relative '../test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should not create a new user when given no parameters' do
    assert_raises ActiveRecord::RecordInvalid do
      User.create!
    end
  end

  test 'should not create a new user with only a name' do
    assert_raises ActiveRecord::RecordInvalid do
      User.create!(name: 'joe')
    end
  end

  test 'should not create a new user without required parameters email & password' do
    assert_raises ActiveRecord::RecordInvalid do
      User.create!(
        name: 'joe',
        home_phone: '123-123-1234',
        work_phone: '123-123-1235',
        carrier: 'A phone carrier',
        hire_date: '12/12/2012'
      )
    end
  end

  test 'should not create a new user without a role' do
    assert_raises ActiveRecord::RecordInvalid do
      User.create!(
        name: 'joe',
        home_phone: '123-123-1234',
        work_phone: '123-123-1235',
        carrier: 'A phone carrier',
        hire_date: '12/12/2012',
        email: 'test@email.com',
        password: 'asdfasdf'
      )
    end
  end

  test 'should create new user with only required parameters' do
    assert_difference('User.count', 1) do
      User.create!(
        name: 'bob',
        email: 'test@email.com',
        password: 'asdfasdf',
        role: 'admin'
      )
    end
  end
end
