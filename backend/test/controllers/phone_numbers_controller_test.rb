require 'test_helper'

class PhoneNumbersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @phone_number = phone_numbers(:one)
  end

  test "should get index" do
    get phone_numbers_url, as: :json
    assert_response :success
  end

  test "should create phone_number" do
    assert_difference('PhoneNumber.count') do
      post phone_numbers_url, params: { phone_number: { contact_id: @phone_number.contact_id, phone_number: @phone_number.phone_number } }, as: :json
    end

    assert_response 201
  end

  test "should show phone_number" do
    get phone_number_url(@phone_number), as: :json
    assert_response :success
  end

  test "should update phone_number" do
    patch phone_number_url(@phone_number), params: { phone_number: { contact_id: @phone_number.contact_id, phone_number: @phone_number.phone_number } }, as: :json
    assert_response 200
  end

  test "should destroy phone_number" do
    assert_difference('PhoneNumber.count', -1) do
      delete phone_number_url(@phone_number), as: :json
    end

    assert_response 204
  end
end
