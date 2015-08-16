class RegistrationsController < Devise::RegistrationsController

  def edit
    current_user.billing_address ||= Address.new(user: current_user)
    current_user.shipping_address ||= Address.new(user: current_user)
    super
  end

  def update
    if params[:billing_address]
      return respond_with current_user.billing_address unless update_billing_address
    end
    if params[:shipping_address]
      return respond_with current_user.shipping_address unless update_shipping_address
    end

    if params[:billing_address] or params[:shipping_address]
      current_user.save
      return redirect_to action: :edit
    end

    # If no addresses we just run original code
    super
  end

  private

  def update_billing_address
    current_user.billing_address ||= Address.new(user: current_user)
    is_updated = current_user.billing_address.update address_params(:billing_address)
    flash[:notice] = I18n.t("devise.registrations.billing_saved") if is_updated
    is_updated
  end

  def update_shipping_address
    current_user.shipping_address ||= Address.new(user: current_user)
    is_updated = current_user.shipping_address.update address_params(:shipping_address)
    flash[:notice] = I18n.t("devise.registrations.shipping_saved") if is_updated
    is_updated
  end

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
  end

  def address_params(type)
    params.require(type).permit(:address, :zip_code, :phone, :city, :country)
  end
end
