class FrontEndController < ApplicationController
require 'httparty'

  def index
    puts params[:text_field];
  end

  def analyse
    render "index";

    text = params[:text_field].gsub('\\', ' ') # replace '\' with ' ' because api can't handle \ yet

    tokens = HTTParty.post("http://pse4.inf.unibe.ch/api/v1/tokenizations", { query: {text: text} } )
    parsed_tokens =  JSON.parse(tokens.body)

    synonym = HTTParty.post("http://pse4.inf.unibe.ch/api/v1/synonyms", {query: {word: "mellitus", count: "2"}})
    parsed_synonym = JSON.parse(synonym.body)



=begin
    parsed_tokens.each do |element|
          puts element
    end

    parsed_synonym.each do |element|
      puts element
    end

    code_proposals = HTTParty.post("http://pse4.inf.unibe.ch/api/v1/code_proposals", {query: {input_codes: ['ICD_E1141'], input_code_types: ['ICD'], get_icds: true, count: 1 }})
    parsed_codes = JSON.parse(code_proposals.body)

    parsed_codes.each do |element|
      puts element
    end
=end

  end

end