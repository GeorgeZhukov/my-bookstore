require 'rails_helper'

RSpec.describe Category, type: :model do

  it { should have_many :books }

  context "validation" do
    it { should validate_presence_of :title }
    it { should validate_uniqueness_of :title }
  end

  describe "#to_s" do
    it "returns title" do
      expect(subject.to_s).to eq subject.title
    end
  end
end
