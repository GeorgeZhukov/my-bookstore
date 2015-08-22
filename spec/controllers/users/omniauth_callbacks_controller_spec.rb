require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  it "calls User.from_omniauth" do
    user = create :facebook_user
    expect(User).to receive(:from_omniauth).and_return(user)
    get :facebook
  end

  it "redirect to sign up page if given information not enough" do
    user = build(:facebook_user, first_name: nil)
    allow(User).to receive(:from_omniauth).and_return(user)
    get :facebook
    expect(response).to redirect_to new_user_registration_path
  end
end
