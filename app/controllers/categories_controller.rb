class CategoriesController < ApplicationController
  load_and_authorize_resource

  add_breadcrumb "Categories", :categories_path

  def index
  end

  def show
    add_breadcrumb @category.title, @caregory
  end
end
