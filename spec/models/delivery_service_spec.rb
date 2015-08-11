require 'rails_helper'

RSpec.describe DeliveryService, type: :model do
  it { expect(subject).to validate_presence_of :name }
  it { expect(subject).to validate_presence_of :price }

  describe ".to_s" do
    it "returns name" do
      expect(subject.to_s).to eq subject.name
    end
  end
end
