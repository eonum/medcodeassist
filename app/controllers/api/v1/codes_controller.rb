class Api::V1::CodesController < Api::V1::APIController
  def create

    codeprefix = nil
    case params[:codetype]
      when 'DRG'
        codeprefix = 'DRG_'
      when 'ICD'
        codeprefix = 'ICD_'
      when 'CHOP'
        codeprefix = 'CHOP_'
    end
    @result = {}
    if codeprefix
      @result = Token.find_similar_codes(params[:code], params[:count].to_i, codeprefix)
    end

    respond_to do |format|
      format.json { render :json => @result }
    end
  end
end
