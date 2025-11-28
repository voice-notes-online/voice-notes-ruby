# frozen_string_literal: true

RSpec.describe VoiceNotes do
  it "has a version number" do
    expect(VoiceNotes::VERSION).not_to be_nil
  end

  describe ".configure" do
    it "yields configuration" do
      VoiceNotes.configure do |config|
        config.api_key = "my_api_key"
        config.base_url = "https://custom.api.com"
      end

      expect(VoiceNotes.configuration.api_key).to eq("my_api_key")
      expect(VoiceNotes.configuration.base_url).to eq("https://custom.api.com")
    end
  end

  describe ".client" do
    it "returns a client instance" do
      expect(VoiceNotes.client).to be_a(VoiceNotes::Client)
    end

    it "memoizes the client" do
      expect(VoiceNotes.client).to be(VoiceNotes.client)
    end

    it "provides access to auth resource" do
      expect(VoiceNotes.client.auth).to be_a(VoiceNotes::Resources::Auth)
    end

    it "provides access to notes resource" do
      expect(VoiceNotes.client.notes).to be_a(VoiceNotes::Resources::Notes)
    end
  end

  describe ".reset!" do
    it "resets the client and configuration" do
      client = VoiceNotes.client
      VoiceNotes.reset!

      expect(VoiceNotes.configuration).to be_nil
      expect(VoiceNotes.client).not_to be(client)
    end
  end
end
