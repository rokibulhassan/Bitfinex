require 'bitfinex'

class BitCoin < ActiveRecord::Base
  attr_accessor :amount_usd, :amount_bit_coin, :total_price, :fees
  after_save :place_order, :send_email_notification

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
    @key = "GtTDzVL0hLFfsf6vjUMwNPdTkPjQRKQutdro9Dm1D76"
    @secret = "CiHfOV0YGIGscVgCsy57OqOqW1ai5yUp8KGzdoSpTfq"

    bfx = Bitfinex.new(@key, @secret)
    begin
      orders = []
      2.times {
        started = Time.now
        res = bfx.order(1, 237, routing: 'bitfinex')

        #  message key is only present on error
        if res['message']
          puts "Error: #{res['message']}"
          exit
        end

        orderid = res['order_id']
        orders << orderid

        puts "[#{Time.now.strftime("%H:%M:%S")}] Placed order #{orderid} (#{res['original_amount']} @ #{res['price']})"

        # Wait for order to execute/be cancelled before buying more
        while (res['is_live']) do
          res = bfx.status(orderid)

          puts "  executed: #{res['executed_amount']}/remaining: #{res['remaining_amount']}"
          sleep 6 if res['is_live']
        end
        wait_time = 60 - (Time.now - started)

        if wait_time > 0
          puts "pausing #{wait_time} before next order ... "
          sleep wait_time
        end
      }

      bfx.summarize_orders(orders)
    rescue => e
      logger.info "Error submitting withdraw request: #{e}"
    end
  end
end
