class Api::V1::TokenizationsController < Api::V1::APIController
  def create
    if params[:text].nil?
      respond_to do |format|
        format.json { render :json => {error: "'text' cannot be empty."}, status: 400 }
      end
      return
    end
    @result = Token.find_tokens(params[:text])
    respond_to do |format|
      format.json { render :json => @result }
    end
  end
end
