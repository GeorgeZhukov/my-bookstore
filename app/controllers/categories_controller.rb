class CategoriesController < ApplicationController
  load_and_authorize_resource

  add_breadcrumb (I18n.t"categories.categories"), :categories_path

  def index
  end

  def show
    add_breadcrumb @category.title, @caregory
    @books = @category.books.page params[:page]
  end
end
