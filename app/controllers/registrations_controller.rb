class RegistrationsController < Devise::RegistrationsController

  def edit
    current_user.billing_address ||= Address.new
    current_user.shipping_address ||= Address.new
    super
  end

  def update
    if params[:billing_address]
      current_user.billing_address ||= Address.new
      is_updated = current_user.billing_address.update address_params(:billing_address)
      flash[:notice] = "The billing address is saved." if is_updated
      return respond_with current_user.billing_address unless is_updated
    end
    if params[:shipping_address]
      current_user.shipping_address ||= Address.new
      is_updated = current_user.shipping_address.update address_params(:shipping_address)
      flash[:notice] = "The shipping address is saved." if is_updated
      return respond_with current_user.shipping_address unless is_updated
    end

    if params[:billing_address] or params[:shipping_address]
      current_user.save
      return redirect_to action: :edit
    end

    # If no addresses we just run original code
    super
  end

  private

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
