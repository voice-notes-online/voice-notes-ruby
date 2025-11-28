# frozen_string_literal: true

require "net/http"
require "json"
require "uri"

module VoiceNotes
  class Client
    attr_accessor :access_token

    def initialize(access_token: nil, base_url: nil)
      @access_token = access_token || VoiceNotes.configuration&.api_key
      @base_url = base_url || VoiceNotes.configuration&.base_url
    end

    def auth
      @auth ||= Resources::Auth.new(self)
    end

    def notes
      @notes ||= Resources::Notes.new(self)
    end

    def get(path, params = {})
      request(:get, path, params)
    end

    def post(path, body = {})
      request(:post, path, body)
    end

    def put(path, body = {})
      request(:put, path, body)
    end

    def delete(path)
      request(:delete, path)
    end

    private

    attr_reader :base_url

    def request(method, path, data = {})
      uri = URI.join(base_url, path)

      uri.query = URI.encode_www_form(data) if method == :get && !data.empty?

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      http.read_timeout = VoiceNotes.configuration&.timeout || 30

      request = build_request(method, uri, data)
      response = http.request(request)

      handle_response(response)
    end

    def build_request(method, uri, data)
      request_class = {
        get: Net::HTTP::Get,
        post: Net::HTTP::Post,
        put: Net::HTTP::Put,
        delete: Net::HTTP::Delete
      }.fetch(method)

      request = request_class.new(uri)
      request["Authorization"] = "Bearer #{access_token}" if access_token
      request["Content-Type"] = "application/json"
      request["Accept"] = "application/vnd.api+json"

      request.body = JSON.generate(data) if %i[post put].include?(method) && !data.empty?

      request
    end

    def handle_response(response)
      case response.code.to_i
      when 200..299
        JSON.parse(response.body) unless response.body.nil? || response.body.empty?
      when 401
        raise AuthenticationError, "Invalid or expired token"
      when 403
        raise AuthorizationError, "Access forbidden"
      when 404
        raise NotFoundError, "Resource not found"
      when 422
        raise ValidationError, parse_error_message(response)
      when 429
        raise RateLimitError, "Rate limit exceeded"
      when 500..599
        raise ServerError, "Server error: #{response.code}"
      else
        raise Error, "Unexpected response: #{response.code}"
      end
    end

    def parse_error_message(response)
      body = JSON.parse(response.body)
      if body["errors"]&.first
        body["errors"].first["detail"] || body["errors"].first["title"]
      else
        body["error"] || body["message"] || "Validation failed"
      end
    rescue JSON::ParserError
      "Validation failed"
    end
  end
end
