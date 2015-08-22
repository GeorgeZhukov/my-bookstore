require 'rails_helper'

RSpec.describe AuthorsController, type: :controller do
  let(:author) { create :author }

  describe "GET index" do
    before { get :index }

    it "assigns @authors" do
      expect(assigns(:authors)).to match_array [author]
    end

    it "renders the index template" do
      expect(response).to render_template("index")
    end
  end

  describe "GET show" do
    before { get :show, id: author.id }

    it "assigns @author" do
      expect(assigns(:author)).to eq author
    end

    it "renders the show template" do
      expect(response).to render_template("show")
    end
  end

end
