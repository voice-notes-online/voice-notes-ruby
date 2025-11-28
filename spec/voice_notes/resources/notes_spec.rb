# frozen_string_literal: true

RSpec.describe VoiceNotes::Resources::Notes do
  let(:client) { VoiceNotes.client }
  let(:notes) { client.notes }

  describe "#find" do
    it "retrieves a note by short ID" do
      stub_request(:get, "https://voice-notes.online/api/v1/notes/abc123")
        .to_return(
          status: 200,
          body: {
            data: {
              id: "abc123",
              type: "note",
              attributes: {
                short_id: "abc123",
                site_url: "https://example.com/article",
                extension_id: "chrome-ext-12345",
                recording_url: "https://storage.example.com/recordings/abc123.webm",
                created_at: "2024-01-15T10:30:00Z",
                updated_at: "2024-01-15T10:30:00Z"
              },
              links: {
                self: "https://voice-notes.online/api/v1/notes/abc123"
              }
            }
          }.to_json,
          headers: { "Content-Type" => "application/vnd.api+json" }
        )

      response = notes.find("abc123")

      expect(response["data"]["id"]).to eq("abc123")
      expect(response["data"]["type"]).to eq("note")
      expect(response["data"]["attributes"]["site_url"]).to eq("https://example.com/article")
      expect(response["data"]["attributes"]["recording_url"]).to include("abc123.webm")
    end

    it "raises NotFoundError when note does not exist" do
      stub_request(:get, "https://voice-notes.online/api/v1/notes/nonexistent")
        .to_return(
          status: 404,
          body: {
            errors: [{
              status: "404",
              code: "not_found",
              title: "Not Found"
            }]
          }.to_json,
          headers: { "Content-Type" => "application/vnd.api+json" }
        )

      expect { notes.find("nonexistent") }.to raise_error(VoiceNotes::NotFoundError)
    end
  end
end
