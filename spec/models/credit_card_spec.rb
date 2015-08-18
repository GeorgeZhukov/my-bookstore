require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  subject { FactoryGirl.create :credit_card }

  it { expect(subject).to have_many :orders }

  context "validation" do
    it { expect(subject).to validate_presence_of :number }
    it { expect(subject).to validate_presence_of :CVV }
    it { expect(subject).to validate_presence_of :expiration_month }
    it { expect(subject).to validate_presence_of :expiration_year }
    it { expect(subject).to validate_presence_of :first_name }
    it { expect(subject).to validate_presence_of :last_name }
    it { expect(subject).to validate_presence_of :user }

    context "expiration date" do
      it "make address invalid if expiration date is 'yesterday'" do
        yesterday = Date.today - 1.day
        subject.expiration_month=yesterday.month
        subject.expiration_year=yesterday.year
        expect(subject).not_to be_valid
      end

      it "make address invalid if expiration date is 'last year'" do
        lastyear = Date.today - 1.year
        subject.expiration_month=lastyear.month
        subject.expiration_year=lastyear.year
        expect(subject).not_to be_valid
      end

      it "make address valid if expiration date is month later" do
        month_later = Date.today + 1.month
        subject.expiration_month=month_later.month
        subject.expiration_year=month_later.year
        expect(subject).to be_valid
      end
    end

  end
end
