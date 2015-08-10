class CartController < ApplicationController
  include Wicked::Wizard

  steps :intro, :address, :delivery, :payment, :confirm

  before_action :set_cart

  add_breadcrumb (I18n.t"cart.cart"), :cart_path

  def show
    jump_to(:intro) if @cart.empty? and step != :intro
    case step
      when :intro
      when :address
        init_addresses
      when :delivery
        init_delivery
      when :payment
        init_credit_card
      when :confirm
        jump_to(:address) unless @cart.shipping_address and @cart.billing_address
        jump_to(:delivery) unless @cart.delivery_service
        jump_to(:payment) unless @cart.credit_card
    end
    render_wizard
  end

  def update
    case step
      when :intro
        update_cart
        return render_wizard unless params[:checkout]
      when :address
        return render_wizard unless update_addresses
      when :delivery
        return redirect_to :back, notice: (I18n.t"cart.delivery.check_delivery") unless update_delivery_service
      when :payment
        return render_wizard unless update_credit_card
      when :confirm
        @cart.checkout!
        return redirect_to order_path(@cart)
    end
    render_wizard @cart
  end

  def clear
    @cart.clear
    redirect_to wizard_path(:intro), notice: (I18n.t"cart.clear.cart_is_cleared")
  end

  def address

  end

  def remove_item
    order_item = @cart.order_items.find params[:item_id]
    order_item.destroy
    if @cart.empty?
      @cart.clear
    end
    redirect_to wizard_path(:intro)
  end

  private

  def set_cart
    @cart = current_or_guest_user.cart
  end

  def init_addresses
    @cart.shipping_address ||= current_or_guest_user.shipping_address || Address.new
    @cart.billing_address ||= current_or_guest_user.billing_address || Address.new
  end

  def init_delivery
    @delivery_services = DeliveryService.all
    @cart.delivery_service ||= @delivery_services[0]
    @cart.save
  end

  def init_credit_card
    @cart.credit_card ||= CreditCard.new
  end

  def update_delivery_service
    @cart.delivery_service = DeliveryService.find_by_id(params[:delivery])
  end

  def update_credit_card
    @cart.credit_card ||= CreditCard.new
    @cart.credit_card.update credit_card_params
  end

  def update_addresses
    @cart.billing_address ||= Address.new
    @cart.shipping_address ||= Address.new
    is_billing_updated = @cart.billing_address.update address_params(:billing_address)

    if params[:use_billing_address] == "yes"
      is_shipping_updated = @cart.shipping_address.update address_params(:billing_address)
    else
      is_shipping_updated = @cart.shipping_address.update address_params(:shipping_address)
    end
    is_shipping_updated && is_billing_updated
  end

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
