require 'rails_helper'

RSpec.describe User, type: :model do
  it{ expect(subject).to have_many :orders }
end
