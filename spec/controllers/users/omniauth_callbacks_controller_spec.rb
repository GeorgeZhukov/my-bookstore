require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  let(:user) { FactoryGirl.create :facebook_user }

  it "calls User.from_omniauth" do
    expect(User).to receive(:from_omniauth).and_return(user)
    get :facebook
  end

  it "redirect to sign up page if given information not enough"
end
