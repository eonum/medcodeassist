class FrontEndController < ApplicationController
require 'httparty'

  def index
    puts params[:text_field];
  end

  def analyse
    render "index";

    text = params[:text_field].gsub!(/[^0-9A-Za-z]/, ' ')

    tokens = HTTParty.post("http://pse4.inf.unibe.ch/api/v1/tokenizations", { query: {text: "Diagnose:
- Morbus Hodgkin (03/93)
  Lokalisation: Lymphknoten mehrerer Regionen (ICD-O 2: C77.8)
  Klassifikation nach Ann Arbor: 3B
- Explorative Laparatomie zum Hodgkin-Staging (03/93)
- Mantelfeldbestrahlung (03/93)
- COPP (06/93)
Begleiterkrankungen:
- insulinpflichtiger Diabetes mellitus (ICD-9 250.-) (gebessert)"} } )

    parsed_tokens =  JSON.parse(tokens.body)

    synonym = HTTParty.post("http://pse4.inf.unibe.ch/api/v1/synonyms", {query: {word: "mellitus", count: "3"}})
    parsed_synonym = JSON.parse(synonym.body)

    code_proposals = HTTParty.post("http://pse4.inf.unibe.ch/api/v1/code_proposals", {query: {input_codes: ['ICD_E1141'], input_code_types: ['ICD'], get_icds: true, count: 1 }})
    #parsed_codes = JSON.parse(code_proposals.body)
    puts code_proposals

    parsed_tokens.each do |element|
          puts element
    end

    parsed_synonym.each do |element|
      puts element
    end
=begin
    parsed_codes.each do |element|
      puts element
    end
=end
  end

end