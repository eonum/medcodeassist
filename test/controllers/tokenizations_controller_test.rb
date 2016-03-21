require 'test_helper'

class TokenizationsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::TokenizationsController.new
  end

  test "should post" do
    post :create, {:format => :json, text: 'hello'}
    assert_response :success
  end

end
