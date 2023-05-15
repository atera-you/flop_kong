require 'rails_helper'
require 'faker'
RSpec.describe SpanController, type: :controller do
  describe 'create' do
    before do
      @user = FactoryBot.create(:user)  
      sign_in @user
    end
    it "下限が入力されなければ上限の値も無効なこと" do
      high_data =  ["d","c","b","a",8,7,6,5,4,3,2]
      low_data = [0,0,0,0,0,0,0,0,0,0,0,0]
      post :create, params: { span: {name: "test",high_pair: 9,low_pair: 0 ,high_suit: high_data,
        low_suit: low_data,high_offsuit: high_data,low_offsuit: low_data} }
      saved_span = Span.last
      expect(saved_span.span).to eq("[[]]")
    end

    it "上限が入力されなければ下限の値も無効なこと" do
      low_data =  ["d","c","b","a",8,7,6,5,4,3,2]
      high_data = [0,0,0,0,0,0,0,0,0,0,0,0]
      post :create, params: { span: {name: "test",high_pair: 9,low_pair: 0 ,high_suit: high_data,
        low_suit: low_data,high_offsuit: high_data,low_offsuit: low_data} }
      saved_span = Span.last
      expect(saved_span.span).to eq("[[]]")
    end
  end
end
