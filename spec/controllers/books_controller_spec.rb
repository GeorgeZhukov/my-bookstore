require 'rails_helper'

RSpec.describe BooksController, type: :controller do

  let(:book) { create :book }

  describe "GET index" do
    it "assigns @books" do
      get :index
      expect(assigns(:books)).to match_array [book]
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    context "search" do
      it "assigns @books associated with search keywords" do
        book1 = create :book
        book2 = create :book

        get :index, search: book2.title
        expect(assigns(:books)).to match_array [book2]
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end
    end
  end

  describe "GET show" do
    it "assigns @book" do
      get :show, id: book.id
      expect(assigns(:book)).to eq book
    end

    it "assigns @new_rating" do

      get :show, id: book.id
      expect(assigns(:new_rating)).not_to be_nil
    end

    it "renders the show template" do
      get :show, id: book.id
      expect(response).to render_template("show")
    end
  end

  describe "PUT add_to_cart" do
    xit "calls #add_book"

    it "redirects to shopping cart with notice" do
      put :add_to_cart, id: book.id, add_to_cart: { quantity: 3 }
      expect(response).to redirect_to cart_path(:intro)
      expect(flash[:notice]).to eq (I18n.t"books.add_to_cart.books_was_successfully_added_to_cart")
    end
  end
end
