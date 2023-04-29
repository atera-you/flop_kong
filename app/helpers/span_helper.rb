module SpanHelper
  #num_pwはポーカーでの役の強さを16進数で強い順に表記している。
  ##g（ハート）、h(ダイヤ)、i（クラブ）、j(スペード)

  def restore_s(high_suit,low_suit)
    num_pw = ["A","K","Q","J","T","9","8","7","6","5","4","3","2"]
    result = []
    JSON.parse(high_suit).zip(JSON.parse(low_suit),num_pw) do |h,l,n| 
      if num_pw.include?(h)&&num_pw.include?(l)
        result <<"#{n}xスートは#{h}から#{l}を含んでいます。"
      else
        result <<"#{n}xスートはレンジに含まれていません。"
      end
    end
    return result
    
  end

  def restore_o(high_offsuit,low_offsuit)
    num_pw = ["A","K","Q","J","T","9","8","7","6","5","4","3","2"]
    result = []
    JSON.parse(high_offsuit).zip(JSON.parse(low_offsuit),num_pw) do |h,l,n| 
      if num_pw.include?(h)&&num_pw.include?(l)
        result <<"#{n}xオフスートは#{h}から#{l}を含んでいます。"
      else
        result <<"#{n}xオフスートはレンジに含まれていません。"
      end
    end
    return result
    
  end

  def restore_f(fi)
    field = []
    fi.each do |f|
      if f[1] == "g"
        field << "ハートの#{f[0]}"
      elsif f[1] == "h" 
        field << "ダイヤの#{f[0]}"
      elsif f[1] == "i"
        field << "クラブの#{f[0]}"
      elsif f[1] == "j"
        field << "スペードの#{f[0]}"
      end
    end
    return field.join(" ")
  end

  def show_result(result_data)
    hand = ["ロイヤルストレートフラッシュ","ストレートフラッシュ","フォーカード","フルハウス","フラッシュ","ストレート","スリーカード","ツーペア","ワンペア","ハイカード"]
    result = []
    result_data.zip(hand) do |r,h|
      result << "#{h}は#{r}成立しています"
    end
    return result
  end
end
