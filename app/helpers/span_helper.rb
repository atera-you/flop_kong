module SpanHelper
  #num_pwはポーカーでの役の強さを16進数で強い順に表記している。
  ##g（ハート）、h(ダイヤ)、i（クラブ）、j(スペード)

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

  def restore_s(high_suit,low_suit)
    num_pw = ["A","K","Q","J","T","9","8","7","6","5","4","3","2"]
    result = []
    JSON.parse(high_suit).zip(JSON.parse(low_suit),num_pw) do |h,l,n| 
      if num_pw.include?(h)&&num_pw.include?(l)
        result <<"#{n}スートは#{h}から#{l}を含んでいます。"
      else
        result <<"#{n}スートはレンジに含まれていません。"
      end
    end
    return result
    
  end

  def restore_o(high_offsuit,low_offsuit)
    num_pw = ["A","K","Q","J","T","9","8","7","6","5","4","3","2"]
    result = []
    JSON.parse(high_offsuit).zip(JSON.parse(low_offsuit),num_pw) do |h,l,n| 
      if num_pw.include?(h)&&num_pw.include?(l)
        result <<"#{n}オフスートは#{h}から#{l}を含んでいます。"
      else
        result <<"#{n}オフスートはレンジに含まれていません。"
      end
    end
    return result
    
  end

end
