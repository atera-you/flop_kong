class Kong

  #カードの定義
  def initialize

    #g（ハート）、h(ダイヤ)、i（クラブ）、j(スペード)
    #数字は16進数（1~d）で1から13を表記
    @cards = "g1,g2,g3,g4,g5,g6,g7,g8,g9,ga,gb,gc,gd"
    @cards = "h1,h2,h3,h4,h5,h6,h7,h8,h9,ha,hb,hc,hd"
    @cards = "i1,i2,i3,i4,i5,i6,i7,i8,i9,ia,ib,ic,id"
    @cards = "j1,j2,j3,j4,j5,j6,j7,j8,j9,ja,jb,jc,jd"
  end

  #カードの総数
  def total
    @card.count
  end



end