require 'rails_helper'

RSpec.describe OrderHelper, type: :helper do
  describe "#state_to_text" do
    it "returns translated state string" do
      [:in_progress, :pending, :in_queue, :canceled].each do |state|
        expect(helper.state_to_text(state)).to eq I18n.t("order_helper.#{state}")
      end
    end
  end
end
