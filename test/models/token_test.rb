require 'test_helper'

class TokenTest < ActiveSupport::TestCase
  test "the truth" do
     assert true
  end

  test "find token" do
    assert_nil Token.find_token("word")
  end
end
