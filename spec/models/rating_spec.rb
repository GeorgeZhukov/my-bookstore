require 'rails_helper'

RSpec.describe Rating, type: :model do
  it { should belong_to :book }
  it { should belong_to :user }

  context "validation" do
    it { should validate_presence_of :number }
    it { should validate_presence_of :review }
    it { should validate_presence_of :book }
    it { should validate_presence_of :user }
  end

  describe ".default_scope" do
    it "returns in descending order" do
      3.times { create :rating }
      expect(Rating.all).to eq Rating.all.order(created_at: :desc)
    end
  end
end
