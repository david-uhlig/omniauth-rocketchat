# frozen_string_literal: true

require "spec_helper"
require "omniauth/strategies/rocketchat"

RSpec.describe OmniAuth::Strategies::RocketChat do
  let(:app) { ->(env) { [200, env, "app"] } }
  let(:strategy) { OmniAuth::Strategies::RocketChat.new(app, "client_id", "client_secret") }

  describe "client options" do
    it "has the correct name" do
      expect(strategy.options.name).to eq("rocketchat")
    end

    it "has the correct authorize_url" do
      expect(strategy.options.client_options.authorize_url).to eq("/oauth/authorize")
    end

    it "has the correct token_url" do
      expect(strategy.options.client_options.token_url).to eq("/oauth/token")
    end

    it "has pkce enabled" do
      expect(strategy.options.pkce).to be_truthy
    end
  end

  describe "#callback_url" do
    let(:full_host) { "https://example.com" }
    let(:script_name) { "/app" }

    before do
      allow(strategy).to receive(:full_host).and_return(full_host)
      allow(strategy).to receive(:script_name).and_return(script_name)
    end

    it "returns the full callback URL" do
      expect(strategy.callback_url).to eq("https://example.com/app/auth/rocketchat/callback")
    end
  end

  describe "authentication hash mapping" do
    let(:profile) do
      {
        "_id" => "123",
        "name" => "John Doe",
        "username" => "johndoe",
        "avatar_url" => "https://example.com/avatar.png",
        "emails" => [
          {"address" => "john@example.com", "verified" => true}
        ]
      }
    end

    before do
      allow(strategy).to receive(:profile).and_return(profile)
    end

    describe "#uid" do
      it "returns the _id from the profile" do
        expect(strategy.uid).to eq("123")
      end
    end

    describe "#info" do
      it "returns name" do
        expect(strategy.info[:name]).to eq("John Doe")
      end

      it "returns email" do
        expect(strategy.info[:email]).to eq("john@example.com")
      end

      it "returns email_verified" do
        expect(strategy.info[:email_verified]).to be_truthy
      end

      it "returns nickname" do
        expect(strategy.info[:nickname]).to eq("johndoe")
      end

      it "returns image" do
        expect(strategy.info[:image]).to eq("https://example.com/avatar.png")
      end
    end

    describe "#extra" do
      it "returns the raw profile info" do
        expect(strategy.extra[:raw_info]).to eq(profile)
      end
    end
  end

  describe "#email" do
    subject { strategy.send(:email) }

    context "when emails is empty" do
      let(:profile) { {"emails" => []} }

      before do
        allow(strategy).to receive(:profile).and_return(profile)
      end

      it "returns a hash with nil address and false verified" do
        expect(subject).to eq({"address" => nil, "verified" => false})
      end
    end

    context "when one email is verified" do
      let(:profile) do
        {
          "emails" => [
            {"address" => "verified@example.com", "verified" => true},
            {"address" => "unverified@example.com", "verified" => false}
          ]
        }
      end

      before do
        allow(strategy).to receive(:profile).and_return(profile)
      end

      it "returns the verified email" do
        expect(subject).to eq({"address" => "verified@example.com", "verified" => true})
      end
    end

    context "when multiple emails are present but none are verified" do
      let(:profile) do
        {
          "emails" => [
            {"address" => "first@example.com", "verified" => false},
            {"address" => "second@example.com", "verified" => false}
          ]
        }
      end

      before do
        allow(strategy).to receive(:profile).and_return(profile)
      end

      it "returns the first email" do
        expect(subject).to eq({"address" => "first@example.com", "verified" => false})
      end
    end
  end
end
