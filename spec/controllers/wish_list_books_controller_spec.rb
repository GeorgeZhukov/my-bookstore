require 'rails_helper'

RSpec.describe WishListBooksController, type: :controller do
  login_user
  let(:book) { create :book }

  describe "GET index" do
    it "assigns @books" do
      @user.get_wish_list.books << book
      get :index
      expect(assigns(:books)).to match_array [book]
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "POST create" do
    it "redirects to book_path with notice" do
      post :create, book_id: book.id
      expect(response).to redirect_to book_path(book)
      expect(flash[:notice]).to eq (I18n.t"wish_list_books.create.successfully_added")
    end

  end

  describe "DELETE destroy" do
    it "redirects back" do
      request.env["HTTP_REFERER"] = "/books"
      post :create, book_id: book.id
      delete :destroy, id: book.id

      expect(response).to redirect_to '/books'
    end
  end
end
