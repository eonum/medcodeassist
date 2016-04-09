class FrontEndController < ApplicationController
require 'httparty'

  def index
    puts params[:text_field];
  end

  def analyse
    render "index";

    text = params[:text_field].gsub!(/[^0-9A-Za-z]/, ' ')

    body = HTTParty.post("http://pse4.inf.unibe.ch/api/v1/tokenizations", { :query => {:text => text} } )
    parsed_body =  JSON.parse(body.body)

    parsed_body.each do |element|
          puts element["token"]
    end
  end

end