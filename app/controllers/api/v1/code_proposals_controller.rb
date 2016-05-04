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
      if not code.nil? # inexisting codes are ignored
        codes[key] = code
      end
    end

    wordvectors = codes.map {|key, code| code.average_wordvector }

    if not params[:text].nil?
      tokens = Token.find_tokens(params[:text], false)
      tokens.each do |token|
        wordvectors.push token[:token].wordvector
      end
    end

    sum = nil
    wordvectors.each do |wordvector|
      if sum
        sum = [sum, wordvector].transpose.map{|x| x.reduce :+}
      else
        sum = wordvector.dup
      end
    end
    average_wordvector = sum.collect {|x| x / sum.length.to_f}

    count = params[:count].nil? ? 3 : params[:count].to_i
    @result = {}
    @result[:procedures] = ChopCode.find_similar_codes(average_wordvector,count)
    @result[:primary_diagnoses] = IcdCode.find_similar_codes(average_wordvector, count)
    @result[:secondary_diagnoses] = @result[:primary_diagnoses]

    respond_to do |format|
      format.json { render :json => @result }
    end
  end
end
