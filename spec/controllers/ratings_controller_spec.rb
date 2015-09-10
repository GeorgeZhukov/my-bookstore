require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  login_user

  before do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(@controller).to receive(:current_ability).and_return(@ability)
    @ability.can :manage, :all
  end

  describe "POST #create" do
    let(:book) { create :book }
    let(:rating_attrs) { attributes_for :rating }

    it "redirect to book path when creates a new rating" do
      post :create, book_id: book.id, rating: rating_attrs
      expect(response).to redirect_to book
    end

    context "cancan doesn't allow create" do
      before do
        @ability.cannot :create, Rating
      end

      it {expect { post :create, book_id: book.id, rating: rating_attrs }.to raise_error(CanCan::AccessDenied)}
    end
  end
end
