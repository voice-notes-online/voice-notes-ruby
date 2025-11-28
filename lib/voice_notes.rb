# frozen_string_literal: true

require_relative "voice_notes/version"
require_relative "voice_notes/configuration"
require_relative "voice_notes/error"
require_relative "voice_notes/client"
require_relative "voice_notes/resources/base"
require_relative "voice_notes/resources/auth"
require_relative "voice_notes/resources/notes"

module VoiceNotes
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.client
    @client ||= Client.new
  end

  def self.reset!
    @client = nil
    @configuration = nil
  end
end
