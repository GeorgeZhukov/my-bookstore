require 'rails_helper'

RSpec.describe WishListBooksController, type: :controller do
  login_user

  describe "GET index" do
    it "assigns @books" do
      book = FactoryGirl.create :book
      @user.get_wish_list.books << book
      get :index
      expect(assigns(:books)).to eq [book]
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
end
