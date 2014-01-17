require 'spec_helper'
require 'photoselect'

describe PhotoSelect do
  describe"given a valid session token for user Zina Eskina"
  it "should get the query facebook for photos" do
    VCR.use_cassette('ZinaEskina#photos') do
      photos = PhotoSelect::fb_connect("CAADcvmCZAfrkBALDJehUnqxZC8il8ZCywTd5UoLCZCjeXAbrGbYdQWZCF7HOq5dl6qhO0bHhIepQJRqnoy2ZAcaCrfo1WigrkabYG0WajIGRtRTmf2dO8ZCFTcdCnk6Cdq5lhMqNSRP3ZCSLmAuN5jMdmOwc6RWD9XJGhNlWykeX09oplWAiiR8LipQ1h48Ac7IZD")
      photos.map{|p| p[:id]}.should include("10151692051396594")
    end
  end
end
