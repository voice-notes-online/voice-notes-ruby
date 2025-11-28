# frozen_string_literal: true

RSpec.describe VoiceNotes::Resources::Auth do
  let(:client) { VoiceNotes.client }
  let(:auth) { client.auth }

  describe "#login" do
    it "sends login request with email and password" do
      stub_request(:post, "https://api.voice-notes.online/api/v1/auth/login")
        .with(
          body: { email: "user@example.com", password: "password123", grant_type: "password" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        .to_return(
          status: 200,
          body: {
            access_token: "access_token_123",
            refresh_token: "refresh_token_456",
            token_type: "Bearer"
          }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      response = auth.login(email: "user@example.com", password: "password123")

      expect(response["access_token"]).to eq("access_token_123")
      expect(response["refresh_token"]).to eq("refresh_token_456")
    end

    it "raises AuthenticationError on invalid credentials" do
      stub_request(:post, "https://api.voice-notes.online/api/v1/auth/login")
        .to_return(status: 401, body: { errors: [{ detail: "Invalid credentials" }] }.to_json)

      expect { auth.login(email: "bad@example.com", password: "wrong") }
        .to raise_error(VoiceNotes::AuthenticationError)
    end
  end

  describe "#refresh" do
    it "sends refresh request with refresh token" do
      stub_request(:post, "https://api.voice-notes.online/api/v1/auth/login")
        .with(
          body: { grant_type: "refresh_token", refresh_token: "refresh_token_456" }.to_json
        )
        .to_return(
          status: 200,
          body: {
            access_token: "new_access_token",
            refresh_token: "new_refresh_token",
            token_type: "Bearer"
          }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      response = auth.refresh(refresh_token: "refresh_token_456")

      expect(response["access_token"]).to eq("new_access_token")
    end
  end

  describe "#logout" do
    it "sends logout request" do
      stub_request(:delete, "https://api.voice-notes.online/api/v1/auth/logout")
        .to_return(status: 204, body: "")

      expect { auth.logout }.not_to raise_error
    end
  end

  describe "#me" do
    it "returns current user data" do
      stub_request(:get, "https://api.voice-notes.online/api/v1/me")
        .to_return(
          status: 200,
          body: {
            data: {
              id: "user-uuid",
              type: "user",
              attributes: {
                email: "user@example.com",
                first_name: "John",
                last_name: "Doe"
              }
            }
          }.to_json,
          headers: { "Content-Type" => "application/vnd.api+json" }
        )

      response = auth.me

      expect(response["data"]["attributes"]["email"]).to eq("user@example.com")
    end

    it "raises AuthenticationError when not logged in" do
      stub_request(:get, "https://api.voice-notes.online/api/v1/me")
        .to_return(status: 401, body: { errors: [{ detail: "User is not logged in" }] }.to_json)

      expect { auth.me }.to raise_error(VoiceNotes::AuthenticationError)
    end
  end
end
