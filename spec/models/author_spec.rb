require 'rails_helper'

RSpec.describe Author, type: :model do
  it { expect(subject).to validate_presence_of :first_name }
  it { expect(subject).to validate_presence_of :last_name }
  it { expect(subject).to have_many :books }
end
