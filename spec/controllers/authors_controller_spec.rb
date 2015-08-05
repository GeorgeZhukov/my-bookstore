require 'rails_helper'

RSpec.describe AuthorsController, type: :controller do
  login_user

  describe "GET index" do
    it "assigns @authors" do
      author = FactoryGirl.create :author
      get :index
      expect(assigns(:authors)).to eq [author]
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
end
