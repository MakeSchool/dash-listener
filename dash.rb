# Note: This program may need to be run as root.
# TODO: This interface needs to be changed to match the interface on the
# server.
interface = "en0"
dash_mac_address = "f0:27:2d:db:27:ec"
log_path = "/tmp/net-traffic"

# spawn ensure that this program runs in a separate parallel process so that
# it doesn't block this one's execution.
pid = spawn("sudo tcpdump -ennqti #{interface}",
              :out => log_path, :err => "/dev/null" )
while true
  File.open(log_path).each do |line|
    puts line
    if line.include?(dash_mac_address)
      puts "button was pressed!"
    end
  end
  # purge the file so we don't end up re-searching through it again.
  File.truncate(log_path, 0)
  # sleep so we're not constantly running the CPU in this loop
  sleep(1)
end
