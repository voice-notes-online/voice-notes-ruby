# Voice Notes Ruby

Ruby client for the Voice Notes API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'voice-notes-ruby'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install voice-notes-ruby
```

## Configuration

```ruby
VoiceNotes.configure do |config|
  config.api_key = "your_access_token"
  config.base_url = "https://voice-notes.online"  # optional, this is the default
  config.timeout = 30  # optional, in seconds
end
```

Or set via environment variables:

```bash
export VOICE_NOTES_API_KEY="your_access_token"
```

## Usage

### Authentication

```ruby
require "voice_notes"

client = VoiceNotes.client

# Login with email and password
response = client.auth.login(email: "user@example.com", password: "password123")
access_token = response["access_token"]
refresh_token = response["refresh_token"]

# Set the access token for subsequent requests
client.access_token = access_token

# Get current user info
me = client.auth.me
puts me["data"]["attributes"]["email"]

# Refresh access token when expired
new_tokens = client.auth.refresh(refresh_token: refresh_token)
client.access_token = new_tokens["access_token"]

# Logout
client.auth.logout
```

### Notes

```ruby
# Retrieve a note by its short ID
note = client.notes.find("abc123")

puts note["data"]["attributes"]["site_url"]
puts note["data"]["attributes"]["recording_url"]
```

### Error Handling

```ruby
begin
  note = client.notes.find("nonexistent")
rescue VoiceNotes::NotFoundError
  puts "Note not found"
rescue VoiceNotes::AuthenticationError
  puts "Invalid or expired token"
rescue VoiceNotes::AuthorizationError
  puts "Access forbidden"
rescue VoiceNotes::ValidationError => e
  puts "Validation error: #{e.message}"
rescue VoiceNotes::RateLimitError
  puts "Rate limit exceeded, try again later"
rescue VoiceNotes::ServerError
  puts "Server error, try again later"
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
