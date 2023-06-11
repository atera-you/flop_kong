class SpanController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  def new
    @span=Span.new
  end

  def create
    
    @span = current_user.spans.build(span_params)
    high_suit = JSON.parse(@span[:high_suit].to_s.gsub("\\",""))
    low_suit = JSON.parse(@span[:low_suit].to_s.gsub("\\",""))
    high_offsuit = JSON.parse(@span[:high_offsuit].to_s.gsub("\\",""))
    low_offsuit = JSON.parse(@span[:low_offsuit].to_s.gsub("\\",""))
    num_sum = selection(high_suit,low_suit)
    offsuit_sum = selection(high_offsuit,low_offsuit)
    span_data = []
    span_data = span_data.concat(pair(@span[:high_pair],@span[:low_pair]),suit(num_sum),offsuit(offsuit_sum))
    @span[:span] = "[#{span_data.to_json}]"
    @span.save
    redirect_to user_path(current_user)
  end

  def show
    @span = Span.find(params[:id])
    @high_pair = a_gsub(@span.high_pair.to_s)
    @low_pair = a_gsub(@span.low_pair.to_s)
    @high_suit = a_gsub(@span.high_suit.to_s)
    @low_suit = a_gsub(@span.low_suit.to_s)
    @high_offsuit = a_gsub(@span.high_offsuit.to_s)
    @low_offsuit = a_gsub(@span.low_offsuit.to_s)

  end

  def calculation 

  end

  def result
    @cal = cal_params
    @span = Span.find(params[:id])
    field = "#{@cal[:card_1].reverse.join}#{@cal[:card_2].reverse.join}#{@cal[:card_3].reverse.join}#{@cal[:card_4].reverse.join}#{@cal[:card_5].reverse.join}"
    span_data = @span[:span].to_s.gsub("\\", "")
    span_array = JSON.parse(span_data)
    @result = calculation(field.gsub("z",""),span_array.flatten)
    session[:field] = field.gsub("z","")
    session[:result] = @result
    redirect_to show_result_span_path(id:@span.id)
  end
  
  def show_result
    @field = a_gsub(session[:field]).scan(/.{2}/)
    @result = session[:result]
  end

  def destroy
    @span = Span.find(params[:id])
    @span.destroy
    redirect_to user_path(current_user)
  end
    
  private
    def span_params
      s_params = params.require(:span).permit(:name,:user_id,:high_pair,:low_pair,high_suit: [],
                                    low_suit: [],high_offsuit: [],low_offsuit:[])
    end

    def cal_params
      params.permit(:authenticity_token,:id,card_1: [],card_2: [],card_3: [],card_4: [],card_5: [])
    end

    def selection(high_num,low_num)
      num_pw = ["1","d","c","b","a","9","8","7","6","5","4","3","2"]
      num_sum = []
      high_num.zip(low_num) do |x, y| 
  
        if num_pw.include?(x)&&num_pw.include?(y)
          u_lim = num_pw.find_index(x)
          l_lim = num_pw.find_index(y)
          num_sum << num_pw.slice(u_lim..l_lim)
        else
          num_sum << []
        end
      end
      return num_sum
    end
  
    def suit(high_low)
      num_pw = ["1","d","c","b","a","9","8","7","6","5","4","3","2"]
      num_sum = []
      high_low.zip(num_pw) do |h_l,n|
        h_l.each do |x|
  
          if x != ""
            
            num_sum << n + "g" + x + "g"
            num_sum << n + "h" + x + "h"
            num_sum << n + "i" + x + "i"
            num_sum << n + "j" + x + "j"
          end
  
        end
      end
  
      return num_sum
    end
  
    def offsuit(high_low)
      num_pw = ["1","d","c","b","a","9","8","7","6","5","4","3","2"]
      num_sum = []
      high_low.zip(num_pw) do |h_l,n|
        h_l.each do |x|
  
          if x != ""
            
            num_sum << n + "g" + x + "h"
            num_sum << n + "g" + x + "i"
            num_sum << n + "g" + x + "j"
            num_sum << n + "h" + x + "g"
            num_sum << n + "h" + x + "i"
            num_sum << n + "h" + x + "j"
            num_sum << n + "i" + x + "g"
            num_sum << n + "i" + x + "h"
            num_sum << n + "i" + x + "g"
            num_sum << n + "j" + x + "g"
            num_sum << n + "j" + x + "h"
            num_sum << n + "j" + x + "i"
          end
  
        end
      end
  
      return num_sum
    end
  
    def pair(high_num,low_num)
      num_pw = ["1","d","c","b","a","9","8","7","6","5","4","3","2"]
      num_sum = []
  
  
        if num_pw.include?(high_num)&&num_pw.include?(low_num)
          u_lim = num_pw.find_index(high_num)
          l_lim = num_pw.find_index(low_num)
          num_pw[u_lim..l_lim].each do |f|
            num_sum << f + "g" + f + "h"
            num_sum << f + "g" + f + "i"
            num_sum << f + "g" + f + "j"
            num_sum << f + "h" + f + "i"
            num_sum << f + "h" + f + "j"
            num_sum << f + "i" + f + "j"
          end
          
        
        else
          num_sum << []
  
        end
      return num_sum
    end

    def a_gsub(g)
      g.gsub(/1|d|c|b|a|/,"1" => "A","d" => "K","c" => "Q","b" => "J","a" => "T")
  
    end


    def calculation(f,hr)
      hand = ["ロイヤルストレートフラッシュ","ストレートフラッシュ","フォーカード","フルハウス","フラッシュ","ストレート","スリーカード","ツーペア","ワンペア","ハイカード"]
      result = []
      rate = []
      hr.each do |h|
        sum_cards = f + h 
        unless duplicate?(sum_cards)
          if RoyalStraightFlush?(f,h)
              result << "ロイヤルストレートフラッシュ"
          elsif StraightFlash?(f,h)
              result << "ストレートフラッシュ"
          elsif FourCard?(f,h)
              result << "フォーカード"
          elsif FullHouse?(f,h)
              result << "フルハウス"
          elsif Flush?(f,h)
              result << "フラッシュ"
          elsif Straight?(f, h)
              result << "ストレート"
          elsif Threecard?(f,h)
              result << "スリーカード"
          elsif Twopair?(f,h)
              result << "ツーペア"
          elsif Onepair?(f,h)
              result << "ワンペア"
          else
              result << "ハイカード"
          end
        else
          next
        end
      end
  
      hand.each do |ha|
        rate << "#{result.count(ha)}/#{result.count}"
      end
      return rate
    end
  
    def duplicate?(sum_cards)
      test = sum_cards.scan(/../)
      sorted_test = test.sort
      sorted_test.each_cons(2) do |test1, test2|
        return true if test1 == test2
      end
      false
    end

    def RoyalStraightFlush?(f,h)
      requirement_flash = ["g","h","i","j"]
      sum_cards = f + h
      sum_cards = sum_cards.gsub("0","1")
      nums = []
      has_flash = false
      has_royalstraight = false
      requirement_flash.each do |r|
        has_flash = true if sum_cards.count(r) >= 5  
      end
      sum_cards.each_char.with_index(1) {|char, i| nums << char if i.odd?}
      nums << "e" if nums.include?("1")
      has_royalstraight = true if nums.include?("a") &&  nums.include?("b") && nums.include?("c") && nums.include?("d") && nums.include?("1") 
      has_flash && has_royalstraight 
    end

    def StraightFlash?(f,h)
      requirement_flash = ["g","h","i","j"]
      sum_cards = f + h
      sum_cards = sum_cards.gsub("0","1")
      nums = []
      has_flash = false
      has_straight = false
      requirement_flash.each do |r|
        has_flash = true if sum_cards.count(r) >= 5 
      end
      sum_cards.each_char.with_index(1) {|char, i| nums << char if i.odd?}
      nums << "e" if nums.include?("1")
      sorted_nums = nums.map {|c| c.to_i(16)}.sort!
      sorted_nums.each_cons(5) do |cards|
        has_straight =  true if cards.each_with_index.all? {|c, i| c == cards[0] + i}
      end
      has_flash && has_straight
    end

    def FourCard?(f,h)
      requirement = ["1","2","3","4","5","6","7","8","9","a","b","c","d","0"]
      sum_cards = f + h
      requirement.each do |r|
        return true if sum_cards.count(r) == 4  
      end
      false
    end

    def FullHouse?(f,h)
      requirement = ["1","2","3","4","5","6","7","8","9","a","b","c","d","0"]
      sum_cards = f + h
      twopair = false
      threecard = false
      requirement.each do |r|
        twopair = true if sum_cards.count(r) == 2 
      end
      requirement.each do |r|
        threecard = true if sum_cards.count(r) == 3  
      end
      twopair && threecard 
    end

    def Flush?(f,h)
      requirement = ["g","h","i","j"]
      sum_cards = f + h
      nums = ""
      sum_cards.each_char.with_index(1) {|char, i| nums << char if i.even?}
      requirement.each do |r|
        return true if sum_cards.count(r) >= 5 
      end
      false
    end

    def Straight?(f, h)
      sum_cards = f + h
      sum_cards = sum_cards.gsub("0","1")
      nums = []
      sum_cards.each_char.with_index(1) {|char, i| nums << char if i.odd?}
      nums << "e" if nums.include?("1")
      sorted_nums = nums.map {|c| c.to_i(16)}.sort!
    
      sorted_nums.each_cons(5) do |cards|
        return true if cards.each_with_index.all? {|c, i| c == cards[0] + i}
      end
      false
    end

    def Threecard?(f,h)
      requirement = ["1","2","3","4","5","6","7","8","9","a","b","c","d","0"]
      sum_cards = f + h
      requirement.each do |r|
        return true if sum_cards.count(r) == 3  
      end
      false
    end

    def Twopair?(f,h)
      requirement = ["1","2","3","4","5","6","7","8","9","a","b","c","d","0"]
      sum_cards = f + h
      count = 0
      requirement.each do |r|
        count +=1 if sum_cards.count(r) >= 2
        return true if count >= 2 
      end
      false
    end

    def Onepair?(f,h)
      requirement = ["1","2","3","4","5","6","7","8","9","a","b","c","d","0"]
      sum_cards = f + h
      requirement.each do |r|
        return true if sum_cards.count(r) == 2
      end
      false
    end
end

