class Api::V1::CodesController < Api::V1::APIController
  def create
    @result = Token.find_similar_codes(params[:code], params[:count].to_i, params[:minlength].to_i)

    respond_to do |format|
      format.json { render :json => @result }
    end
  end
end
