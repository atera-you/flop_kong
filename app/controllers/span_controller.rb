class SpanController < ApplicationController
  include SpanHelper
  before_action :authenticate_user!, only: [:create]
  def new
    @span=Span.new
  end

  def create
    @span = current_user.spans.build(span_params)
    high_suit = JSON.parse(@span[:high_suit].gsub("\\",""))
    low_suit = JSON.parse(@span[:low_suit].gsub("\\",""))
    high_offsuit = JSON.parse(@span[:high_offsuit].gsub("\\",""))
    low_offsuit = JSON.parse(@span[:low_offsuit].gsub("\\",""))

    num_sum = selection(high_suit,low_suit)
    offsuit_sum = selection(high_offsuit,low_offsuit)
    @span[:span] = pair(@span[:high_pair],@span[:low_pair]).to_json +
            suit(num_sum).to_json +
            offsuit(offsuit_sum).to_json
    @span.save
    redirect_to user_path(current_user)

  end

  def show
    @span = Span.find(params[:id])
    @high_pair = a_gsub(@span.high_pair)
    @low_pair = a_gsub(@span.low_pair)
    @high_suit = a_gsub(@span.high_suit)
    @low_suit = a_gsub(@span.low_suit)
    @high_offsuit = a_gsub(@span.high_offsuit)
    @low_offsuit = a_gsub(@span.low_offsuit)

  end

  def calculation 
    @cal = {}
  end

  def result
    @cal = cal_params
    @span = Span.find(@cal[:id])
  end
    
    





  private
    def span_params
      params.require(:span).permit(:name,:user_id,:high_pair,:low_pair,high_suit: [],
                                    low_suit: [],high_offsuit: [],low_offsuit:[])
    end

    def cal_params
      params.permit(:authenticity_token,:id,card_1: [],card_2: [],card_3: [],card_4: [],card_5: [])
    end

    def a_gsub(g)
      g.gsub(/1|d|c|b|a|/,"1" => "A","d" => "K","c" => "Q","d" => "J","a" => "T")
  
    end


end
