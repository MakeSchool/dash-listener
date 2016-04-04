require 'net/http'
require 'uri'
require 'json'

class SlackAlerter
  attr_accessor :message_spacing_hours
  attr_accessor :time_last_pressed

  def initialize(uri, text, emoji, message_spacing_hours=12)
    @uri = uri
    @text = text
    @emoji = emoji
    @message_spacing_hours = message_spacing_hours
    @time_last_pressed = 0
  end

  def alert()
    current_time = Time.now
    difference_time = (current_time - @time_last_pressed).to_i / (60 * 60)

    @time_last_pressed = current_time
    if difference_time < @message_spacing_hours
      return false
    end

    https = Net::HTTP.new(@uri.host, @uri.port)
    https.use_ssl = true  # Use https
    request = Net::HTTP::Post.new(@uri.request_uri)

    request["Content-Type"] = "application/json"  # Add http request header
    payload={
      "channel" => "#random",
      "username" => "gatekeeper",
      "text" => @text,
      "icon_emoji" => @emoji }.to_json
    request.body = payload  # Set JSON to request body
    response = https.request(request)
    return true
  end
end
