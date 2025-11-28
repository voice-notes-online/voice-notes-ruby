# frozen_string_literal: true

module VoiceNotes
  class Configuration
    attr_accessor :api_key, :base_url, :timeout

    def initialize
      @api_key = ENV.fetch("VOICE_NOTES_API_KEY", nil)
      @base_url = ENV.fetch("VOICE_NOTES_BASE_URL", "https://api.voice-notes.online")
      @timeout = 30
    end
  end
end
