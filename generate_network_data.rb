#!/use/bin/env ruby

# Generates a hiera file containing network addresses for SSL key generation

require 'socket'
require 'yaml'

OUTPUT_FILE = 'netdata.yaml'

# abort if the file already exists
if File.exist?(OUTPUT_FILE)
  exit
end

# determine the current DNS name and primary IP address
hostname = Socket.gethostname
ip_address = Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }.ip_address

netdata = {}
netdata["netdata"] = {}
netdata["netdata"]["primary_name"] = hostname

alt_names = []
alt_names.push(ip_address)
alt_names.push('localhost')
alt_names.push('127.0.0.1')
netdata["netdata"]["alt_names"] = alt_names

File.write(OUTPUT_FILE, YAML.dump(netdata))
