require 'spec_helper'

describe Token do
  before do
    token = Token.new(:name =>"Mirko",:lang =>'de',:wordvector=>['halll','ouups'])
    token.save

  end



  it 'should return nil' do
    #expect(Token.find_tokens("")).to be(null)
  end
end