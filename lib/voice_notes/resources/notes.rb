# frozen_string_literal: true

module VoiceNotes
  module Resources
    class Notes < Base
      # Retrieve a voice note by its short ID
      # @param id [String] The Base58 short ID of the note
      # @return [Hash] Note data in JSON:API format
      def find(id)
        get("/api/v1/notes/#{id}")
      end
    end
  end
end
