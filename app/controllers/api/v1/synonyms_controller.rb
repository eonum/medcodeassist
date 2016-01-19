class Api::V1::SynonymsController < Api::V1::APIController
  def create
    @result = nil
    token = Token.find_token(params[:token])
    if token
      @result = token.find_similar_tokens # This is an approximation (Retrieves similar tokens based on the word vectors instead of true synonyms.).
    end
    respond_to do |format|
      format.json { render :json => @result }
    end
  end
end
