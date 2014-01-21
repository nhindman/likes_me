require 'spec_helper'
require 'photoselect'

describe PhotoSelect do
  describe "given a valid session token for user Zina Eskina"
  it "should get the query facebook for photos" do
    VCR.use_cassette('ZinaEskina#photos') do
      photos = PhotoSelect::fb_connect("<paste session token here>")
      photos.map{|p| p[:id]}.should include("10151692051396594")
    end
  end
end
