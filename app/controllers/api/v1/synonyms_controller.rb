class Api::V1::SynonymsController < Api::V1::APIController
  def create
    count = params[:count].nil? ? 3 : params[:count].to_i
    @result = nil
    token = Token.find_token(params[:word])
    if not token.nil?
      @result = token.find_similar_tokens count  # This is an approximation (Retrieves similar tokens based on the word vectors instead of true synonyms.).
    end
    respond_to do |format|
      format.json { render :json => @result }
    end
  end
end
