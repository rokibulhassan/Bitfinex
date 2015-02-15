class BitCoinsController < ApplicationController
  before_action :set_bit_coin, only: [:show, :edit, :update, :destroy]
  # https://github.com/jwilkins/bitfinex
  # https://docs.google.com/document/d/1H6-DGErgDr-pC4m2xoh1v3mfNcDBiuq8s40fB5I35TY/edit
  # GET /bit_coins
  # GET /bit_coins.json
  def index
    @bit_coins = BitCoin.all
  end

  # GET /bit_coins/1
  # GET /bit_coins/1.json
  def show
  end

  # GET /bit_coins/new
  def new
    @key = "GtTDzVL0hLFfsf6vjUMwNPdTkPjQRKQutdro9Dm1D76"
    @secret = "CiHfOV0YGIGscVgCsy57OqOqW1ai5yUp8KGzdoSpTfq"
    @bit_coin = BitCoin.new
  end

  # GET /bit_coins/1/edit
  def edit
  end

  # POST /bit_coins
  # POST /bit_coins.json
  def create
    @bit_coin = BitCoin.new(bit_coin_params)

    respond_to do |format|
      if @bit_coin.save
        format.html { redirect_to @bit_coin, notice: 'Bit coin was successfully created.' }
        format.json { render action: 'show', status: :created, location: @bit_coin }
      else
        format.html { render action: 'new' }
        format.json { render json: @bit_coin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bit_coins/1
  # PATCH/PUT /bit_coins/1.json
  def update
    respond_to do |format|
      if @bit_coin.update(bit_coin_params)
        format.html { redirect_to @bit_coin, notice: 'Bit coin was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @bit_coin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bit_coins/1
  # DELETE /bit_coins/1.json
  def destroy
    @bit_coin.destroy
    respond_to do |format|
      format.html { redirect_to bit_coins_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_bit_coin
    @bit_coin = BitCoin.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bit_coin_params
    params.require(:bit_coin).permit(:wallet_address, :user_email, :fees, :total_price, :app_price)
  end
end
