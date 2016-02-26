class Api::V1::CodeProposalsController < Api::V1::APIController
  def create
    input_code_classes = {}
    input_code_types = params[:input_code_types] ? params[:input_code_types] : {}
    input_code_types.each do |key, input_code_type|
      case input_code_type
        when 'DRG'
          input_code_class = Drg
        when 'ICD'
          input_code_class = IcdCode
        when 'CHOP'
          input_code_class = ChopCode
      end
      input_code_classes[key] = input_code_class
      if input_code_classes.length == 0
        respond_to do |format|
          format.json { render :json => {error: "An input_code_type you specified couldn't be found."}, status: 400 }
        end
        return
      end
    end

    codes = {}
    input_codes = params[:input_codes] ? params[:input_codes] : {}
    input_codes.each do |key, input_code|
      code = input_code_classes[key].where({code: input_code}).first
      if code.nil?
        respond_to do |format|
          format.json { render :json => {error: "An input code you specified coulnd't be found."}, status: 400 }
        end
        return
      end
      codes[key] = code
    end

    wordvectors = codes.map {|key, code| code.average_wordvector }
    sum = nil
    wordvectors.each do |wordvector|
      if sum
        sum = [sum, wordvector].transpose.map{|x| x.reduce :+}
      else
        sum = wordvector.dup
      end
    end
    average_wordvector = sum.collect {|x| x / sum.length.to_f}

    get_drgs = params[:get_drgs] == 'true'
    get_chops = params[:get_chops] == 'true'
    get_icds = params[:get_icds] == 'true'

    @result = {}
    if params[:count].to_i > 0 and (get_drgs or get_chops or get_icds)
      if get_drgs
        @result[:drgs] = Drg.find_similar_codes(average_wordvector, params[:count].to_i)
      end
      if get_chops
        @result[:chops] = ChopCode.find_similar_codes(average_wordvector, params[:count].to_i)
      end
      if get_icds
        @result[:icds] = IcdCode.find_similar_codes(average_wordvector, params[:count].to_i)
      end
    end

    respond_to do |format|
      format.json { render :json => @result }
    end
  end
end
