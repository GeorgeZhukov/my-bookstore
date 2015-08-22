require 'rails_helper'

RSpec.describe WishList, type: :model do
  it { should belong_to :user }
  it { should have_and_belong_to_many :books }
  it { should validate_presence_of :user }
end
