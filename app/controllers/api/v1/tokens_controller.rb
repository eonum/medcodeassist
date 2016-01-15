class Api::V1::TokensController < Api::V1::APIController
  def create
    @result = Token.find_tokens(params[:text])
    respond_to do |format|
      format.json { render :json => @result }
    end
  end
end
