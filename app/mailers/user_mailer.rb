class UserMailer < ApplicationMailer
  def delivered_email(user, order)
    @user = user
    @order = order
    @url  = order_url(order)
    mail(to: @user.email, subject: 'Your order is delivered successfully.')
  end
end
