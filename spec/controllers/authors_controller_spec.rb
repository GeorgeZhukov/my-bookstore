require 'rails_helper'

RSpec.describe AuthorsController, type: :controller do
  login_user
  let(:author) { FactoryGirl.create :author }

  xdescribe "GET index" do
    it "assigns @authors" do
      get :index
      expect(assigns(:authors).to_a).to eq [author]
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  xdescribe "GET show" do
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
