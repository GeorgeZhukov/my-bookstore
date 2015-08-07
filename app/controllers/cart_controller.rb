class CartController < ApplicationController
  include Wicked::Wizard

  steps :intro, :address, :delivery, :payment, :confirm, :checkout

  add_breadcrumb "Cart", :cart_path

  def show
    @cart = current_or_guest_user.cart
    case step
      when :intro
      when :address
        @cart.shipping_address ||= current_or_guest_user.shipping_address || Address.new
        @cart.billing_address ||= current_or_guest_user.billing_address || Address.new
      when :delivery
        @delivery_services = DeliveryService.all
        @selected = @cart.delivery_service || @delivery_services[0]
      when :payment
        @cart.credit_card ||= CreditCard.new
      when :confirm
        jump_to(:address) unless @cart.shipping_address and @cart.billing_address
        jump_to(:delivery) unless @cart.delivery_service
        jump_to(:payment) unless @cart.credit_card
      when :checkout
        @cart.checkout!
    end
    render_wizard
  end

  def update
    @cart = current_or_guest_user.cart
    case step
      when :intro
        params[:items].each do |item|
          # todo: check  id
          order_item = @cart.order_items.find(item[:id])
          order_item.quantity = item[:quantity]
          order_item.save
        end
        return render_wizard unless params[:checkout]
      when :address
        @cart.billing_address ||= Address.new
        @cart.shipping_address ||= Address.new
        is_billing_updated = @cart.billing_address.update address_params(:billing_address)
        is_shipping_updated = @cart.shipping_address.update address_params(:shipping_address)

        unless is_billing_updated and is_shipping_updated
          return render_wizard
        end
      when :delivery
        ds = DeliveryService.find_by_id(params[:delivery])
        return redirect_to :back, notice: "Check delivery service" unless ds
        @cart.delivery_service = ds
      when :payment
        @credit_card = @cart.credit_card ||= CreditCard.new
        return render_wizard unless @cart.credit_card.update(credit_card_params)
    end
    render_wizard @cart
  end

  def clear
    current_or_guest_user.cart.clear
    redirect_to wizard_path(:intro), notice: "Your cart is cleared."
  end

  def address

  end

  def remove_item
    order_item = current_or_guest_user.cart.order_items.find params[:item_id]
    order_item.destroy
    redirect_to wizard_path(:intro)
  end

  private
  def credit_card_params
    params.require(:credit_card).permit(:number, :CVV, :expiration_month, :expiration_year, :first_name, :last_name)
  end

  def address_params(type)
    params.require(type).permit(:address, :zip_code, :phone, :city, :country)
  end
end
