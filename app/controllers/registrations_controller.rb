class RegistrationsController < Devise::RegistrationsController

  def edit
    current_user.billing_address ||= Address.new(user: current_user)
    current_user.shipping_address ||= Address.new(user: current_user)
    super
  end

  def update
    if params[:billing_address]
      return respond_with current_user.billing_address unless update_address :billing_address
    end
    if params[:shipping_address]
      return respond_with current_user.shipping_address unless update_address :shipping_address
    end

    if params[:billing_address] or params[:shipping_address]
      current_user.save
      return redirect_to action: :edit
    end

    # If no addresses we just run original code
    super
  end

  private

  def update_address(type)
    address = current_user.send("#{type}") || Address.new(user: current_user)
    current_user.send("#{type}=", address)
    is_updated = address.update address_params(type)
    flash[:notice] = I18n.t("devise.registrations.#{type}_saved") if is_updated
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
