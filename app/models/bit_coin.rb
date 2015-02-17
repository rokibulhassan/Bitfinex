require 'bitfinex'

class BitCoin < ActiveRecord::Base
  attr_accessor :usd_amount, :btc_amount, :total_price, :fee
  validate :place_order
  after_save :send_email_notification

  def btc_to_usd(live_price, btc_amount)
    usd_amount = btc_amount * live_price
    usd_amount.to_f
  end

  def usd_to_btc(live_price, usd_amount)
    btc_amount = usd_amount.to_f / live_price.to_f
    btc_amount.to_f
  end

  def send_email_notification
    UserMailer.transaction_notification(self).deliver
  end

  def place_order
    begin
      bfx = Bitfinex.new(ENV['key'], ENV['secret'])
      price = self.balance - self.app_price*0.003
      puts [balance, app_price, price]
      res = bfx.order(0.01, price, {routing: 'bitfinex'})
      order_id = res['order_id']
      logger.info "[#{Time.now.strftime("%H:%M:%S")}] Placed order #{order_id} (#{res['original_amount']} @ #{res['price']})"
    rescue => ex
      logger.info "Error::: #{ex}"
      raise ex
    end
  end
end
