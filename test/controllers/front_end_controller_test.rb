require 'test_helper'

class FrondEndControllerTest < ActionController::TestCase
  def setup
    @controller = FrontEndController.new
  end

  test "should get index with q=hello" do
    get :index, {'q' => 'hello'}
    assert_response :success
    assert_equal('hello', assigns['text'])
  end

end
