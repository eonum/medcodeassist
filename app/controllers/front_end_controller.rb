class FrontEndController < ApplicationController
require 'httparty'

  def index
    puts params[:text_field];
  end

  def analyse
  end

end