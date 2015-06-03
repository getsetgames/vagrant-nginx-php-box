#!/use/bin/env ruby

# Generates a hiera JSON file containing network addresses for SSL key generation

require 'socket'
require 'json'

OUTPUT_FILE = 'netdata.json'

# abort if the file already exists
if File.exist?(OUTPUT_FILE)
  exit
end

# determine the current DNS name and primary IP address
hostname = Socket.gethostname
ip_address = Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }.ip_address

netdata = {}
netdata["primary_name"] = hostname

alt_names = []
alt_names.push(ip_address)
alt_names.push('localhost')
alt_names.push('127.0.0.1')
netdata["alt_names"] = alt_names

File.write(OUTPUT_FILE, JSON.pretty_generate(netdata))
