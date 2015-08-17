require 'rails_helper'

RSpec.describe Rating, type: :model do
  it { expect(subject).to belong_to :book }
  it { expect(subject).to belong_to :user }
  it { expect(subject).to validate_presence_of :number }
  it { expect(subject).to validate_presence_of :review }
  it { expect(subject).to validate_presence_of :book }
  it { expect(subject).to validate_presence_of :user }

  describe ".default_scope" do
    it "returns in descending order" do
      3.times { FactoryGirl.create :rating }
      expect(Rating.all).to eq Rating.all.order(created_at: :desc)
    end
  end
end
