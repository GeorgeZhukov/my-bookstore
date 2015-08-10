require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  login_user

  let(:book) { FactoryGirl.create :book }

  describe "GET index" do
    it "assigns @books" do
      get :index
      expect(assigns(:books)).to eq [book]
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET show" do
    it "assigns @book" do
      get :show, id: book.id
      expect(assigns(:book)).to eq book
    end

    it "renders the show template" do
      get :show, id: book.id
      expect(response).to render_template("show")
    end
  end
end
