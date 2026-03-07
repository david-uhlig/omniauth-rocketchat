# frozen_string_literal: true

RSpec.describe OmniAuth::RocketChat do
  context "version number" do
    it "has a version number" do
      expect(OmniAuth::RocketChat::VERSION).not_to be nil
    end

    it "matches RubyGems' requirements" do
      expect(Gem::Version.correct?(OmniAuth::RocketChat::VERSION)).to be_truthy
    end
  end
end
