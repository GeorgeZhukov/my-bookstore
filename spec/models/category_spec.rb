require 'rails_helper'

RSpec.describe Category, type: :model do
  it { expect(subject).to validate_presence_of :title }
  it { expect(subject).to validate_uniqueness_of :title }
  it { expect(subject).to have_many :books }

  describe ".to_s" do
    it "returns title" do
      expect(subject.to_s).to eq subject.title
    end
  end
end
