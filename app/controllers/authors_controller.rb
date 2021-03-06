class AuthorsController < ApplicationController
  load_and_authorize_resource
  add_breadcrumb (I18n.t"authors.authors"), :authors_path

  def index
    @authors = @authors.page params[:page]
  end

  def show
    add_breadcrumb @author.to_s, @author
  end
end
