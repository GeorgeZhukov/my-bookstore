require 'rails_helper'

RSpec.describe Address, type: :model do
  it { expect(subject).to validate_presence_of :address }
  it { expect(subject).to validate_presence_of :zip_code }
  it { expect(subject).to validate_presence_of :city }
  it { expect(subject).to validate_presence_of :phone }
  it { expect(subject).to validate_presence_of :country }
  it { expect(subject).to validate_presence_of :user }
  it { expect(subject).to belong_to :user }

  describe ".eq" do
    it "returns true if all fields in address1 equal to all fields in address2" do
      address1 = FactoryGirl.create :address
      address2 = FactoryGirl.create :address
      address2.id = address1.id
      expect(address1.eq(address2)).to be_truthy
    end

    it "returns true if id of address1 is eq to id of address2" do
      address1 = FactoryGirl.create :address
      expect(address1.eq(address1)).to be_truthy
    end
  end

  describe ".country_name" do
    it "returns United States when country is 'us'" do
      subject.country = "us"
      expect(subject.country_name).to eq "United States"
    end
  end
end
