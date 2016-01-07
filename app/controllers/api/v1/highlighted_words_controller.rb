class Api::V1::HighlightedWordsController < Api::V1::APIController
  def create
    @result = [{word:"gehen", stemmed_form:"geh", start: 0, length: 5}]
    respond_to do |format|
      format.json { render :json => @result }
    end
  end

end
