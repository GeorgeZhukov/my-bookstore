require 'rails_helper'
require 'carrierwave/test/matchers'

describe BookCoverUploader do
  include CarrierWave::Test::Matchers
  let(:book) { create :book }

  before do
    @uploader = BookCoverUploader.new(book, :cover)

    File.open("fixtures/images/atlascover.jpg") do |f|
      @uploader.store!(f)
    end
  end

  after do
    @uploader.remove!
  end

  # context 'the thumb version' do
  #   it "should scale down a landscape image to be exactly 64 by 64 pixels" do
  #     @uploader.thumb.should have_dimensions(64, 64)
  #   end
  # end
end