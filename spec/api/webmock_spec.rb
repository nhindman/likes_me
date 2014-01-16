require 'spec_helper'
require 'photoselect'

describe PhotoSelect do
  describe"given a valid session token for user Zina Eskina"
  it "should get the query facebook for photos" do
    VCR.use_cassette('ZinaEskina#photos') do
      photos = PhotoSelect::fb_connect("CAADcvmCZAfrkBAIPwV3z3jHP1m3onftL9ffw4Kz8X80oei23qeHpNY3gDfYtvmzrF7QoJyhZAXJA9D2TT5uUV3rXS0i3cy2gUZAnXWIG3rtDynzaU7fZAmDh8bUdjIaCRRUCiSayQIsZCNyZBiCs1zL2DWRPvWnO7YvLmSNt7dDuX9WAxIH3wi")
      photos.map{|p| p[:id]}.should include("10151692051396594")
    end
  end
  # it "should get the query facebook for photos" do
  #   VCR.use_cassette('ZinaEskina#photos') do
  #     photos = PhotoSelect::fb_connect("CAADcvmCZAfrkBAIPwV3z3jHP1m3onftL9ffw4Kz8X80oei23qeHpNY3gDfYtvmzrF7QoJyhZAXJA9D2TT5uUV3rXS0i3cy2gUZAnXWIG3rtDynzaU7fZAmDh8bUdjIaCRRUCiSayQIsZCNyZBiCs1zL2DWRPvWnO7YvLmSNt7dDuX9WAxIH3wi")
  #     photos.map{|p| p[:id]}.should include("10151692051396594")
  #   end
  # end
end
