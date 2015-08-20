require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create :user }


  it{ expect(subject).to have_many :orders }
  it{ expect(subject).to have_many :ratings }
  it{ expect(subject).to have_one :wish_list }
  it{ expect(subject).to belong_to :billing_address }
  it{ expect(subject).to belong_to :shipping_address }

  context "validation" do
    it{ expect(subject).to validate_presence_of :first_name }
    it{ expect(subject).to validate_presence_of :last_name }
  end

  describe "#cart" do
    it "returns an order which has state :in_progress" do
      expect(subject.cart.state).to eq "in_progress"
    end

    it "creates a new order if no orders with state :in_progress"

    it "returns the order which has state :in_progress" do
      Order.destroy_all
      order = create :order, user: subject
      expect(subject.cart).to eq order
    end
  end

  describe "#move_orders_to" do
    let(:book) { create :book }
    let(:user2) { create :user }

    it "move shopping cart items from user1 to user2" do
      subject.cart.add_book book
      expect { subject.move_orders_to user2 }.to change{ user2.cart.empty? }.from(true).to(false)
    end

    it "changes user_id for other orders" do
      subject.cart.add_book book
      order = subject.cart
      order.checkout!
      order.confirm!
      order.finish!
      expect { subject.move_orders_to user2 }.to change{ user2.orders.where.not(state: :in_progress).count }.by(1)
    end
  end

  describe "#to_s" do
    it "returns first_name + last_name" do
      expect(subject.to_s).to eq "#{subject.first_name} #{subject.last_name}"
    end

    it "returns 'Guest' if user is a guest" do
      guest = create :user, guest: true
      expect(guest.to_s).to eq "Guest"

    end
  end
  describe "#name" do
    it "returns .to_s" do
      expect(subject.name).to eq subject.to_s
    end
  end

  describe "#avatar_url" do
    it "returns avatar field if it presence"
    it "returns gravatar url if avatar field is empty"
  end

  describe "#get_wish_list" do
    it "returns current wish list if exists"
    it "creates a new wish list if current wish list is empty"
  end

  describe ".from_omniauth" do
    let(:user) { create :facebook_user }

    it "returns the user with current credentials" do
      auth = double("auth")
      allow(auth).to receive(:provider).and_return(user.provider)
      allow(auth).to receive(:uid).and_return(user.uid)
      expect(User.from_omniauth(auth)).to eq user
    end

    it "returns creates a new user" do
      user = build :facebook_user
      auth = double("auth")
      allow(auth).to receive(:provider).and_return(user.provider)
      allow(auth).to receive(:uid).and_return(user.uid)

      info = double("info")
      allow(info).to receive(:email).and_return(user.email)
      allow(info).to receive(:first_name).and_return(user.first_name)
      allow(info).to receive(:last_name).and_return(user.last_name)
      allow(info).to receive(:image).and_return(user.avatar)

      allow(auth).to receive(:info).and_return(info)

      expect { User.from_omniauth(auth) }.to change { User.count }.by(1)
    end
  end
end
