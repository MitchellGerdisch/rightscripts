#!/usr/bin/sudo /usr/bin/python
# Inputs:
# $NETWORK_ID
# $NETWORK_NAME

import json
from pprint import pprint
from shutil import copyfile
import os

# Build the new network entry.
network_id = os.environ['NETWORK_ID']   # E.g. network-13
network_name = os.environ['NETWORK_NAME'] # E.g. datacenter1/Public NIC
network_entry = '{"id": "'+network_id+'","name": "'+network_name+'","ip_assignment": "dhcp","rs_connectivity": "default-gw"}'
json_parsed_network_entry = json.loads(network_entry)

# Open the config file for the RCA-V and read it in as JSON
with open('/etc/vscale.conf') as vscale_conf_file:
        vscale_conf_json = json.load(vscale_conf_file)

# Add the new network entry to the networks array in the JSON.
networks_array = vscale_conf_json['networks']
networks_array.append(json_parsed_network_entry)
vscale_conf_json['networks'] = networks_array

# Create a new version of the vscale.conf file with the new JSON
# NOTE: The RCA-V/RightScale interaction appears to be somewhat formatting sensitive. So use indent=4 to format the JSON in the file.
with open('/etc/vscale.conf.new','w') as new_vscale_conf_file:
        json.dump(vscale_conf_json, new_vscale_conf_file, indent=4)
    
# Backup the existing vscale.conf file and apply the new file
copyfile('/etc/vscale.conf', '/etc/vscale.conf.old')
copyfile('/etc/vscale.conf.new', '/etc/vscale.conf')