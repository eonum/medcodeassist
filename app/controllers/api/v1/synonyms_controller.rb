class Api::V1::SynonymsController < Api::V1::APIController
  def create
    count = params[:count]
    @result = nil
    token = Token.find_token(params[:token])
    if not token.nil?
      @result = token.find_similar_tokens count.to_i  # This is an approximation (Retrieves similar tokens based on the word vectors instead of true synonyms.).
    end
    respond_to do |format|
      format.json { render :json => @result }
    end
  end
end
