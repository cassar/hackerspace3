require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test 'should get show' do
    get manage_account_url
    assert_response :success
  end

  test 'should get edit' do
    get update_personal_details_url
    assert_response :success
  end

  # FIX: Should be testing update, but want it broken up into smaller
  # controllers first
end
