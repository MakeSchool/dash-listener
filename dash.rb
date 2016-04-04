require './slack_alerter'

SLACK_URI = URI.parse("https://hooks.slack.com/services/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")
ALERT_TEXT = "The building is open; commence hacking"
ALERT_EMOJI = ":robot_face:"

slack_alerter = SlackAlerter.new( SLACK_URI, ALERT_TEXT, ALERT_EMOJI )

# This interface needs to be changed to match the interface on the server.
WIFI_INTERFACE = "en0"

DASH_MAC_ADDRESS = "f0:27:2d:db:27:ec"
LOG_PATH = "/tmp/net-traffic"

# spawn ensure that this program runs in a separate parallel process so that
# it doesn't block this one's execution.
pid = spawn("sudo tcpdump -ennqti #{interface}",
              :out => log_path, :err => "/dev/null" )

# make sure we start with an empty file
File.truncate(log_path, 0) if File.exist?(log_path)

while true
  File.open(log_path).each do |line|
    puts line
    if line.include?(dash_mac_address)
      puts "***** button was pressed! *****"
      slack_alerter.alert()
    end
  end
  # purge the file so we don't end up re-searching through it again.
  File.truncate(log_path, 0)
  # sleep so we're not constantly running the CPU in this loop
  sleep(1)
end
