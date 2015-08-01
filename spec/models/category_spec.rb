require 'rails_helper'

RSpec.describe Category, type: :model do
  it { expect(subject).to validate_presence_of :title }
  it { expect(subject).to validate_uniqueness_of :title }
  it { expect(subject).to have_many :books }
end
