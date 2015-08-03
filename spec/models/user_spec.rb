require 'rails_helper'

RSpec.describe User, type: :model do
  it{ expect(subject).to have_many :orders }
  it{ expect(subject).to have_many :ratings }

  describe ".cart" do
    xit "returns an order which has state :in_progress" do
      expect(subject.cart.state).to eq :in_progress
    end
  end
end
