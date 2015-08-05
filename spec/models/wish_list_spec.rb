require 'rails_helper'

RSpec.describe WishList, type: :model do
  it { expect(subject).to belong_to :user }
  it { expect(subject).to have_and_belong_to_many :books }
end
