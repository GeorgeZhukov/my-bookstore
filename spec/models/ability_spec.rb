require 'rails_helper'
require "cancan/matchers"

describe User do
  let(:user) { FactoryGirl.create :user }

  xdescribe "abilities" do
    subject(:ability){ Ability.new(user) }

    context "when is an admin" do
      let(:user){ FactoryGirl.create :admin }

      it { expect(subject).to be_able_to(:manage, :all) }
    end


    it { expect(subject).to be_able_to(:read, Book.new) }
    it { expect(subject).to be_able_to(:new_rating, Book.new) }
    it { expect(subject).to be_able_to(:read, Category.new) }
    it { expect(subject).to be_able_to(:read, Author.new) }
    it { expect(subject).to be_able_to(:manage, Address.new(user: user)) }
    # it { expect(subject).to be_able_to(:create, Rating.new(user: user)) }
    # it { expect(subject).to be_able_to(:read, Rating.new(user: user)) }

    context "unauthorized actions" do
      it { expect(subject).not_to be_able_to(:edit, Book.new) }
      it { expect(subject).not_to be_able_to(:delete, Book.new) }
      it { expect(subject).not_to be_able_to(:edit, Rating.new) }
      it { expect(subject).not_to be_able_to(:delete, Rating.new) }
      it { expect(subject).not_to be_able_to(:edit, Address.new) }
      it { expect(subject).not_to be_able_to(:delete, Address.new) }
      it { expect(subject).not_to be_able_to(:edit, Author.new) }
      it { expect(subject).not_to be_able_to(:delete, Author.new) }
    end
  end
end