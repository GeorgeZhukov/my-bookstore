class CartController < ApplicationController
  include Wicked::Wizard

  steps :intro, :address, :delivery, :payment, :confirm

  add_breadcrumb (I18n.t"cart.cart"), :cart_path

  def show
    @cart = current_or_guest_user.cart
    case step
      when :intro
      when :address
        @cart.shipping_address ||= current_or_guest_user.shipping_address || Address.new
        @cart.billing_address ||= current_or_guest_user.billing_address || Address.new
      when :delivery
        @delivery_services = DeliveryService.all
        @cart.delivery_service ||= @delivery_services[0]
        @cart.save
      when :payment
        @cart.credit_card ||= CreditCard.new
      when :confirm
        jump_to(:address) unless @cart.shipping_address and @cart.billing_address
        jump_to(:delivery) unless @cart.delivery_service
        jump_to(:payment) unless @cart.credit_card
    end
    render_wizard
  end

  def update
    @cart = current_or_guest_user.cart
    case step
      when :intro
        update_cart
        return render_wizard unless params[:checkout]
      when :address
        @cart.billing_address ||= Address.new
        @cart.shipping_address ||= Address.new
        is_billing_updated = @cart.billing_address.update address_params(:billing_address)

        if params[:use_billing_address] == "yes"
          is_shipping_updated = @cart.shipping_address.update address_params(:billing_address)
        else
          is_shipping_updated = @cart.shipping_address.update address_params(:shipping_address)
        end

        unless is_billing_updated and is_shipping_updated
          return render_wizard
        end
      when :delivery
        ds = DeliveryService.find_by_id(params[:delivery])
        return redirect_to :back, notice: (I18n.t"cart.delivery.check_delivery") unless ds
        @cart.delivery_service = ds
      when :payment
        @credit_card = @cart.credit_card ||= CreditCard.new
        return render_wizard unless @cart.credit_card.update(credit_card_params)
      when :confirm
        @cart.checkout!
        return redirect_to order_path(@cart)
    end
    render_wizard @cart
  end

  def clear
    current_or_guest_user.cart.clear
    redirect_to wizard_path(:intro), notice: (I18n.t"cart.clear.cart_is_cleared")
  end

  def address

  end

  def remove_item
    order_item = current_or_guest_user.cart.order_items.find params[:item_id]
    order_item.destroy
    if current_or_guest_user.cart.empty?
      current_or_guest_user.cart.clear
    end
    redirect_to wizard_path(:intro)
  end

  private
  def update_cart
    params[:items].each do |item|
      order_item = @cart.order_items.find(item[:id])
      order_item.update(quantity: item[:quantity])
    end
  end

  def credit_card_params
    params.require(:credit_card).permit(:number, :CVV, :expiration_month, :expiration_year, :first_name, :last_name)
  end

  def address_params(type)
    params.require(type).permit(:address, :zip_code, :phone, :city, :country)
  end
end
