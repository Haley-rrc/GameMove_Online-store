require "test_helper"

class CheckoutControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get checkout_new_url
    assert_response :success
  end

  test "should get review" do
    get checkout_review_url
    assert_response :success
  end
end
