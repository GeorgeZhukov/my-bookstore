require 'rails_helper'

RSpec.describe Author, type: :model do
  it { expect(subject).to validate_presence_of :first_name }
  it { expect(subject).to validate_presence_of :last_name }
  it { expect(subject).to have_many :books }

  describe ".to_s" do
    it "returns first_name + last_name" do
      author = FactoryGirl.create :author
      expect(author.to_s).to eq "#{author.first_name} #{author.last_name}"
    end
  end
end
