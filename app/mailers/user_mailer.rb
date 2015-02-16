class UserMailer < ActionMailer::Base
  default from: "info@bitsbridge.com"

  def transaction_notification(object)
    @email = object.user_email
    @balance = object.balance
    @app_price = object.app_price
    @wallet_address = object.wallet_address
    @created_at = object.created_at
    mail(:to => [@email], :subject => "Transaction Notification")
  end
end
