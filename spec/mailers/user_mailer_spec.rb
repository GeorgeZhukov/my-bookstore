require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { FactoryGirl.create :user }
  let(:order) { FactoryGirl.create :order, user: user }
  let(:mail) { UserMailer.delivered_email(user, order) }

  it 'renders the subject' do
    expect(mail.subject).to eq I18n.t("user_mailer.delivered_email.order_delivered", number: order.number)
  end

  it 'renders the receiver email' do
    expect(mail.to).to match_array [user.email]
  end

  it 'renders the sender email' do
    expect(mail.from).to match_array ['scofield.cross@gmail.com']
  end

  it "prints order number" do
    expect(mail.body.encoded).to match order.number
  end
  it "assigns @order"
  it "assigns @url"
end
