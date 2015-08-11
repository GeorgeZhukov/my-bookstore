require 'rails_helper'

RSpec.describe Author, type: :model do
  subject { FactoryGirl.create :author }

  it { expect(subject).to validate_presence_of :first_name }
  it { expect(subject).to validate_presence_of :last_name }
  it { expect(subject).to have_many :books }

  describe ".to_s" do
    it "returns first_name + last_name" do
      expect(subject.to_s).to eq "#{subject.first_name} #{subject.last_name}"
    end
  end

  describe ".name" do
    it "returns .to_s" do
      expect(subject.name).to eq subject.to_s
    end
  end
end
