require 'rails_helper'
require "cancan/matchers"

describe User do
  describe "abilities" do
    context "admin" do
      subject { Ability.new(create(:admin)) }

      it { should be_able_to :manage, :all }
    end

    context "user" do
      let(:user) { create(:user) }
      subject { Ability.new(user) }

      context "book" do
        it { should be_able_to :read, Book.new }
        it { should be_able_to :add_to_cart, Book.new }
        it { should_not be_able_to :create, Book.new }
        it { should_not be_able_to :edit, Book.new }
        it { should_not be_able_to :delete, Book.new }
      end

      context "author" do
        it { should be_able_to :read, Author.new }
        it { should_not be_able_to :create, Author.new }
        it { should_not be_able_to :edit, Author.new }
        it { should_not be_able_to :delete, Author.new }
      end

      context "category" do
        it { should be_able_to :read, Category.new }
        it { should_not be_able_to :create, Category.new }
        it { should_not be_able_to :edit, Category.new }
        it { should_not be_able_to :delete, Category.new }
      end

      context "rating" do
        it { should be_able_to :read, Rating.new(state: :approved) }
        it { should_not be_able_to :read, Rating.new }
        it { should be_able_to :create, Rating.new(user: user) } # only with current user id
        it { should_not be_able_to :create, Rating.new }
        it { should_not be_able_to :edit, Rating.new }
        it { should_not be_able_to :delete, Rating.new }
      end

      context "order" do
        it { should be_able_to :read, Order.new(user: user)}
        it { should_not be_able_to :read, Order.new }
        it { should_not be_able_to :create, Order.new }
        it { should_not be_able_to :edit, Order.new }
        it { should_not be_able_to :delete, Order.new }
      end

      context "credit card" do
        it { should_not be_able_to :read, CreditCard.new }
        it { should_not be_able_to :create, CreditCard.new }
        it { should_not be_able_to :edit, CreditCard.new }
        it { should_not be_able_to :delete, CreditCard.new }
      end

      context "address" do
        it { should be_able_to :read, Address.new(user: user) }
        it { should_not be_able_to :read, Address.new }
        it { should_not be_able_to :create, Address.new }
        it { should_not be_able_to :edit, Address.new }
        it { should_not be_able_to :delete, Address.new }
      end

      context "delivery service" do
        it { should be_able_to :read, DeliveryService.new }
        it { should_not be_able_to :create, DeliveryService.new }
        it { should_not be_able_to :edit, DeliveryService.new }
        it { should_not be_able_to :delete, DeliveryService.new }
      end

      context "order item" do
        it { should_not be_able_to :read, OrderItem.new }
        it { should_not be_able_to :create, OrderItem.new }
        it { should_not be_able_to :edit, OrderItem.new }
        it { should_not be_able_to :delete, OrderItem.new }
      end

      context "user" do
        it { should_not be_able_to :read, User.new }
        it { should_not be_able_to :create, User.new }
        it { should_not be_able_to :edit, User.new }
        it { should_not be_able_to :delete, User.new }
      end

      context "wish list" do
        it { should be_able_to :read, WishList.new(user: user)}
        it { should_not be_able_to :read, WishList.new }
        it { should_not be_able_to :create, WishList.new }
        it { should_not be_able_to :edit, WishList.new }
        it { should_not be_able_to :delete, WishList.new }
      end
    end

    context "guest" do
      subject { Ability.new(create(:user, guest: true)) }

      context "book" do
        it { should be_able_to :read, Book.new }
        it { should be_able_to :add_to_cart, Book.new }
        it { should_not be_able_to :create, Book.new }
        it { should_not be_able_to :edit, Book.new }
        it { should_not be_able_to :delete, Book.new }
      end

      context "author" do
        it { should be_able_to :read, Author.new }
        it { should_not be_able_to :create, Author.new }
        it { should_not be_able_to :edit, Author.new }
        it { should_not be_able_to :delete, Author.new }
      end

      context "category" do
        it { should be_able_to :read, Category.new }
        it { should_not be_able_to :create, Category.new }
        it { should_not be_able_to :edit, Category.new }
        it { should_not be_able_to :delete, Category.new }
      end

      context "rating" do
        it { should be_able_to :read, Rating.new(state: :approved) }
        it { should_not be_able_to :read, Rating.new }
        it { should_not be_able_to :create, Rating.new }
        it { should_not be_able_to :edit, Rating.new }
        it { should_not be_able_to :delete, Rating.new }
      end

      context "order" do
        it { should_not be_able_to :read, Order.new }
        it { should_not be_able_to :create, Order.new }
        it { should_not be_able_to :edit, Order.new }
        it { should_not be_able_to :delete, Order.new }
      end

      context "credit card" do
        it { should_not be_able_to :read, CreditCard.new }
        it { should_not be_able_to :create, CreditCard.new }
        it { should_not be_able_to :edit, CreditCard.new }
        it { should_not be_able_to :delete, CreditCard.new }
      end

      context "address" do
        it { should_not be_able_to :read, Address.new }
        it { should_not be_able_to :create, Address.new }
        it { should_not be_able_to :edit, Address.new }
        it { should_not be_able_to :delete, Address.new }
      end

      context "delivery service" do
        it { should be_able_to :read, DeliveryService.new }
        it { should_not be_able_to :create, DeliveryService.new }
        it { should_not be_able_to :edit, DeliveryService.new }
        it { should_not be_able_to :delete, DeliveryService.new }
      end

      context "order item" do
        it { should_not be_able_to :read, OrderItem.new }
        it { should_not be_able_to :create, OrderItem.new }
        it { should_not be_able_to :edit, OrderItem.new }
        it { should_not be_able_to :delete, OrderItem.new }
      end

      context "user" do
        it { should_not be_able_to :read, User.new }
        it { should_not be_able_to :create, User.new }
        it { should_not be_able_to :edit, User.new }
        it { should_not be_able_to :delete, User.new }
      end

      context "wish list" do
        it { should_not be_able_to :read, WishList.new }
        it { should_not be_able_to :create, WishList.new }
        it { should_not be_able_to :edit, WishList.new }
        it { should_not be_able_to :delete, WishList.new }
      end
    end
  end
end