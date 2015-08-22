require 'rails_helper'

RSpec.describe Address, type: :model do
  subject { create :address }
  it { expect(subject).to belong_to :user }

  context "validation" do
    it { expect(subject).to validate_presence_of :address }
    it { expect(subject).to validate_presence_of :zip_code }
    it { expect(subject).to validate_presence_of :city }
    it { expect(subject).to validate_presence_of :phone }
    it { expect(subject).to validate_presence_of :country }
    it { expect(subject).to validate_presence_of :user }
  end

  describe "#eq" do
    it "returns true if all fields in address1 equal to all fields in address2" do
      address1 = create :address
      address2 = create :address
      address2.id = address1.id
      expect(address1.eq(address2)).to be_truthy
    end

    it "returns true if id of address1 is eq to id of address2" do
      address1 = create :address
      expect(address1.eq(address1)).to be_truthy
    end
  end

  describe "#country_name" do
    it "returns United States when country is 'us'" do
      subject.country = "us"
      expect(subject.country_name).to eq "United States"
    end
    it "returns Ukraine when country is 'ua'" do
      subject.country = "ua"
      expect(subject.country_name).to eq "Ukraine"
    end
  end

  describe "#full_address" do
    it { expect(subject.full_address).to eq "#{subject.address}, #{subject.city}, #{subject.zip_code}, #{subject.country.upcase}" }
  end

  describe "#coords" do
    it "calls Geocoder.coordinates with #full_address" do
      allow(subject).to receive(:full_address).and_return(:full_address)
      expect(Geocoder).to receive(:coordinates).with(:full_address).once
      subject.coords
    end
  end
end
