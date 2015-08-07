require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryGirl.create :user }
  it{ expect(subject).to have_many :orders }
  it{ expect(subject).to have_many :ratings }

  describe ".cart" do
    it "returns an order which has state :in_progress" do
      expect(subject.cart.state).to eq "in_progress"
    end
  end

  describe "to_s" do
    it "returns first_name + last_name" do
      expect(subject.to_s).to eq "#{subject.first_name} #{subject.last_name}"
    end
  end
end
