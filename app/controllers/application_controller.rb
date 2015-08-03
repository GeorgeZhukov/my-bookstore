class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :init_categories

  helper_method :current_user

  def current_user
    super || guest_user
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  def init_categories
    @categories = Category.all
  end

  private

  def guest_user
    session[:guest_user_id] = create_guest_user.id if session[:guest_user_id].nil?
    User.find(session[:guest_user_id])
  end

  def create_guest_user
    user = User.new { |user| user.guest = true }
    user.email = "guest_#{Time.now.to_i}#{rand(99)}@example.com"
    user.save(:validate => false)
    user
  end

end
