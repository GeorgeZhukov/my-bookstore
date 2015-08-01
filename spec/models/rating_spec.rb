require 'rails_helper'

RSpec.describe Rating, type: :model do
  it { expect(subject).to belong_to :book }
  it { expect(subject).to belong_to :user }
end
