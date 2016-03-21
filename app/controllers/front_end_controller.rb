class FrontEndController < ApplicationController
  def index
    @model = TestModel.new("TestModelName")
    @text = front_end_params #params[:q]
  end

  private
  def front_end_params
    params.require(:q)
  end
end