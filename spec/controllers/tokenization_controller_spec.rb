require 'spec_helper'
require 'rails_helper'


describe Api::V1::TokenizationsController do

  before do
    @token = Token.new(:name =>"Mirko",:lang =>'de',:wordvector=>[0,1])
    @token2 = Token.new(:name =>"Simon",:lang =>'de',:wordvector=>[0,1])
    @token3 = Token.new(:name =>"Jiannis",:lang =>'de',:wordvector=>[0,1])
    @token4 = Token.new(:name =>"Antonis",:lang =>'de',:wordvector=>[0,1])
    @token5 = Token.new(:name =>"Lucien",:lang =>'de',:wordvector=>[0,1])
    @token.save
    @token2.save
    @token3.save
    @token4.save
    @token5.save
  end

    it 'test controller method create' do
      expect(@controller.respond_to?(:create)).to be(true)
      get :create, {:format => :json, text: "Mirko, Simon, Jiannis, Antonis, Lucien"}

      parsed_body = JSON.parse(response.body)

      # puts parsed_body[0]["word"] # uncomment if you wanna look how the parsed_body 2D-array looks like

      expect(parsed_body[0]["word"].eql?("Mirko")).to be(true)
      expect(parsed_body[0]["token"].eql?("Mirko")).to be(true)
      expect(parsed_body[0]["pos"]).to be(0)


      expect(parsed_body[1]["word"].eql?("Simon")).to be(true)
      expect(parsed_body[1]["token"].eql?("Simon")).to be(true)
      expect(parsed_body[1]["pos"]).to be(7)

      expect(parsed_body[2]["word"].eql?("Jiannis")).to be(true)
      expect(parsed_body[2]["token"].eql?("Jiannis")).to be(true)
      expect(parsed_body[2]["pos"]).to be(14)

      expect(parsed_body[3]["word"].eql?("Antonis")).to be(true)
      expect(parsed_body[3]["token"].eql?("Antonis")).to be(true)
      expect(parsed_body[3]["pos"]).to be(23)

      expect(parsed_body[4]["word"].eql?("Lucien")).to be(true)
      expect(parsed_body[4]["token"].eql?("Lucien")).to be(true)
      expect(parsed_body[4]["pos"]).to be(32)
    end

    it 'test similarity of tokens' do
      expect(Token.count).to be(5)
      expect(@token2.name.eql?("Simon")).to be(true)
      expect(@token.find_similar_tokens.include?({:token=>"Simon", :similarity=>1.0})).to be(true)
    end
end