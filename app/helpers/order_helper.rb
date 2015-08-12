module OrderHelper
  def state_to_text(state)
    I18n.t("order_helper.#{state.to_s}")
  end
end
