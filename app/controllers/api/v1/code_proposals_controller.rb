class Api::V1::CodeProposalsController < Api::V1::APIController
  def create
    input_code_class = nil
    case params[:input_code_type]
      when 'DRG'
        input_code_class = Drg
      when 'ICD'
        input_code_class = IcdCode
      when 'CHOP'
        input_code_class = ChopCode
    end

    if input_code_class.nil?
      respond_to do |format|
        format.json { render :json => {error: "You didn't specify an input_code_type."}, status: 400 }
      end
      return
    end

    errors = []
    code = input_code_class.where({code: params[:input_code]}).first
    if code.nil?
      respond_to do |format|
        format.json { render :json => {error: "The input code you specified coulnd't be found."}, status: 400 }
      end
      return
    end
    
    get_drgs = params[:get_drgs] == 'true'
    get_chops = params[:get_chops] == 'true'
    get_icds = params[:get_icds] == 'true'

    @result = {}
    if input_code_class and params[:count].to_i > 0 and (get_drgs or get_chops or get_icds)
      if code
        if get_drgs
          @result[:drgs] = Drg.find_similar_codes(code, params[:count].to_i)
        end
        if get_chops
          @result[:chops] = ChopCode.find_similar_codes(code, params[:count].to_i)
        end
        if get_icds
          @result[:icds] = IcdCode.find_similar_codes(code, params[:count].to_i)
        end
      end
    end

    respond_to do |format|
      format.json { render :json => @result }
    end
  end
end
