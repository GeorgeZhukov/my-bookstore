class UserMailer < ApplicationMailer
  def delivered_email(user, order)
    @user = user
    @order = order
    @url  = order_url(order)
    mail(to: @user.email, subject: I18n.t("user_mailer.delivered_email.order_delivered", number: order.number))
  end
end
