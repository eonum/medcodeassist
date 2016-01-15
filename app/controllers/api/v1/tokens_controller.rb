class Api::V1::TokensController < Api::V1::APIController
  def create
    @result = [{word:"gehen", token:"geh", start: 0, length: 5}]
    respond_to do |format|
      format.json { render :json => @result }
    end
  end
end
