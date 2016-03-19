require 'spec_helper'
require 'rails_helper'


describe 'TokenizationController' do

  before do
    token = Token.new(:name =>"Mirko",:lang =>'de',:wordvector=>['halll','ouups'])
    token.save
    @controller = Api::V1::TokenizationsController.new
  end

  describe 'POST #create' do
    it 'should be successful' do

      post :create, {:format => :json, text: 'hello'}
      response.should be_success
      #expect(response).to must_be_empty
    end
  end


end