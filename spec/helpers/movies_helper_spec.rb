require "rails_helper"


RSpec.describe MoviesHelper, :type => :helper do
  describe "checking odd or even" do
    it "should return odd if the input is 1" do
      expect(helper.oddness(1)).to eq("odd")
    end
    it "should return even if the input is 2" do
      expect(helper.oddness(2)).to eq("even")
    end
  end
end