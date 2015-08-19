require 'rails_helper'

RSpec.describe AuthorsController, type: :controller do
  let(:author) { create :author }

  describe "GET index" do
    it "assigns @authors" do
      get :index
      expect(assigns(:authors)).to match_array [author]
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET show" do
    it "assigns @author" do
      get :show, id: author.id
      expect(assigns(:author)).to eq author
    end

    it "renders the show template" do
      get :show, id: author.id
      expect(response).to render_template("show")
    end
  end
end
