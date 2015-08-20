class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :init_categories
  layout "application_with_categories"

  helper_method :current_or_guest_user

  add_breadcrumb (I18n.t("home")), :root_path

  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        guest = User.find session[:guest_user_id]
        guest.move_orders_to current_user
        guest.destroy
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # Checks if current user is NOT a guest
  def user_signed_in?
    super && current_user
  end

  def current_ability
    @current_ability ||= Ability.new(current_or_guest_user)
  end

  def init_categories
    @categories = Category.all
  end

  private

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user(with_retry = true)
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
    session[:guest_user_id] = nil
    guest_user if with_retry
  end

  def create_guest_user
    u = User.create_guest
    session[:guest_user_id] = u.id
    u
  end

end
