require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryGirl.create :user }

  it{ expect(subject).to validate_presence_of :first_name }
  it{ expect(subject).to validate_presence_of :last_name }
  it{ expect(subject).to have_many :orders }
  it{ expect(subject).to have_many :ratings }
  it{ expect(subject).to have_one :wish_list }
  it{ expect(subject).to belong_to :billing_address }
  it{ expect(subject).to belong_to :shipping_address }

  describe ".cart" do
    it "returns an order which has state :in_progress" do
      expect(subject.cart.state).to eq "in_progress"
    end

    it "creates a new order if no orders with state :in_progress"

    it "returns the order which has state :in_progress" do
      Order.destroy_all
      order = FactoryGirl.create :order, user: subject
      expect(subject.cart).to eq order
    end
  end

  describe ".to_s" do
    it "returns first_name + last_name" do
      expect(subject.to_s).to eq "#{subject.first_name} #{subject.last_name}"
    end

    it "returns 'Guest' if user is a guest" do
      guest = FactoryGirl.create :user, guest: true
      expect(guest.to_s).to eq "Guest"

    end
  end
  describe ".name" do
    it "returns .to_s" do
      expect(subject.name).to eq subject.to_s
    end
  end

  describe ".avatar_url" do
    it "returns avatar field if it presence"
    it "returns gravatar url if avatar field is empty"
  end

  describe ".get_wish_list" do
    it "returns current wish list if exists"
    it "creates a new wish list if current wish list is empty"
  end
end
