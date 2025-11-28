# frozen_string_literal: true

module VoiceNotes
  module Resources
    class Auth < Base
      # Login with email and password
      # @param email [String] User's email
      # @param password [String] User's password
      # @return [Hash] Response containing access_token and refresh_token
      def login(email:, password:)
        post("/api/v1/auth/login", {
               email: email,
               password: password,
               grant_type: "password"
             })
      end

      # Refresh access token using refresh token
      # @param refresh_token [String] The refresh token
      # @return [Hash] Response containing new access_token and refresh_token
      def refresh(refresh_token:)
        post("/api/v1/auth/login", {
               grant_type: "refresh_token",
               refresh_token: refresh_token
             })
      end

      # Logout and invalidate the current session
      # @return [Hash, nil] Response from server
      def logout
        delete("/api/v1/auth/logout")
      end

      # Get current authenticated user
      # @return [Hash] User data in JSON:API format
      def me
        get("/api/v1/me")
      end
    end
  end
end
