require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  setup do
    @profile = profiles(:one)
    @user = users(:one)
    @employment_status = employment_statuses(:one)
  end

  test 'associations' do
    assert @profile.user == @user
    assert profiles(:one).holders.include? holders(:one)
    assert @profile.employment_status == @employment_status

    @profile.destroy

    assert_raises(ActiveRecord::RecordNotFound) { holders(:one).reload }
    assert_raises(ActiveRecord::RecordNotFound) { @employment_status.reload }
  end

  test 'validations' do
    assert_not Profile.create(identifier: @profile.identifier).save
  end

  test 'scopes' do
    assert_not Profile.published.include? @profile
  end

  test 'enums' do
    assert Profile.first_peoples.is_a? Hash
    assert Profile.disabilities.is_a? Hash
    assert Profile.educations.is_a? Hash
    assert Profile.ages.is_a? Hash
    assert Profile.team_statuses.is_a? Hash
  end

  test 'update_identifier callback' do
    @profile.touch
    @profile.reload
    assert_equal 'user_number_one', @profile.identifier

    @user.update preferred_name: 'example name'
    @profile.reload
    assert_equal 'example_name', @profile.identifier
  end

  test 'accept_code_of_conduct_before_publish' do
    @user.update! accepted_code_of_conduct: false

    assert_raises(ActiveRecord::RecordInvalid) do
      @profile.update!(published: true)
    end
  end
end
