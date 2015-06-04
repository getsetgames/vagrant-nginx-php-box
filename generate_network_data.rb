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

# output to a YAML file to be read by hiera
netdata = {}
netdata["netdata"] = {}
netdata["netdata"]["primary_name"] = hostname
netdata["netdata"]["primary_ip"] = ip_address

File.write(OUTPUT_FILE, YAML.dump(netdata))
