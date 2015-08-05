require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  login_user

  describe "GET index" do
    it "assigns @books" do
      book = FactoryGirl.create :book
      get :index
      expect(assigns(:books)).to eq [book]
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
end
