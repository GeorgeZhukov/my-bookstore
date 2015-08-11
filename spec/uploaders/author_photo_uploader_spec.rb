require 'rails_helper'
require 'carrierwave/test/matchers'

describe AuthorPhotoUploader do
  include CarrierWave::Test::Matchers
  let(:author) { FactoryGirl.create :author }

  before do
    @uploader = AuthorPhotoUploader.new(author, :photo)

    File.open("fixtures/images/ayn_rand.jpg") do |f|
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