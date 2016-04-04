require "minitest/autorun"
require "minitest/reporters"
require "./slack_alerter"
require "byebug"
Minitest::Reporters.use!

class TestMeme < Minitest::Test
  def setup
    uri = URI.parse("https://hooks.slack.com/services/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")
    text = "The building is open; commence hacking"
    emoji = ":robot_face:"
    hour_spacing = 1
    @alerter = SlackAlerter.new( uri, text, emoji, hour_spacing)
  end

  def test_exists
    assert @alerter != nil
  end

  def test_sends_alert
    is_success = @alerter.alert
    assert is_success == true
  end

  def test_respects_hour_spacing
    # send first
    @alerter.alert
    # attempt to send the second
    is_success = @alerter.alert
    assert is_success == false
    # space an hour artificially
    one_hour = 60 * 60
    @alerter.time_last_pressed = Time.now - one_hour
    is_success = @alerter.alert
    assert is_success == true
  end
end
