class KongController < ApplicationController
  def new
    @kong = Kong.new
  end
end
