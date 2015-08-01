require 'rails_helper'

RSpec.describe Address, type: :model do
  it { expect(subject).to validate_presence_of :address }
  it { expect(subject).to validate_presence_of :zip_code }
  it { expect(subject).to validate_presence_of :city }
  it { expect(subject).to validate_presence_of :phone }
end
