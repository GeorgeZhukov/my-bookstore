require 'rails_helper'

RSpec.describe DeliveryService, type: :model do
  it { expect(subject).to validate_presence_of :name }
  it { expect(subject).to validate_presence_of :price }
end
