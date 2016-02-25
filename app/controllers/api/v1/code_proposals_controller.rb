class Api::V1::CodeProposalsController < Api::V1::APIController
  def create
    code_class_from = nil
    case params[:code_type_from]
      when 'DRG'
        code_class_from = Drg
      when 'ICD'
        code_class_from = IcdCode
      when 'CHOP'
        code_class_from = ChopCode
    end

    code_class_to = nil
    case params[:code_type_to]
      when 'DRG'
        code_class_to = Drg
      when 'ICD'
        code_class_to = IcdCode
      when 'CHOP'
        code_class_to = ChopCode
    end


    @result = {}
    if code_class_from and code_class_to and params[:count].to_i > 0
      code = code_class_from.where({code: params[:code]}).first
      if code
        @result = code_class_to.find_similar_codes(code, params[:count].to_i)
      end
    end

    respond_to do |format|
      format.json { render :json => @result }
    end
  end
end
