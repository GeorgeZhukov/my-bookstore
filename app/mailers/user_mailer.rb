class UserMailer < ApplicationMailer
  def delivered_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Your order is delivered successfully.')
  end
end
