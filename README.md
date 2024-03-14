import json
import os

def check_md_dns(hostname, infoblox_cookie, cl_args):
    """Check for -md DNS Record in INFOBLOX and create it if it doesn't exist."""
    # Form the name for the md record
    md_record = f"{hostname}-md"

    # Parse the IP from the json file
    ip_file_path = cl_args.infofile
    if os.path.exists(ip_file_path):
        with open(ip_file_path, 'r', encoding='ascii') as file:
            nic_info = json.load(file)
            # Assuming 'tickPublisherCidr' is the correct field for the IP
            ip_cidr = nic_info.get('tickPublisherCidr', '')
            # Extract just the IP address part from the CIDR notation
            ip_address = ip_cidr.split('/')[0] if ip_cidr else 'desired.fallback.ip.address'
    else:
        print(f"Error: File {ip_file_path} does not exist.")
        return

    # Use the infoblox_get function to check if the record already exists
    endpoint = f"record:host?name={md_record}"
    response = infoblox_get(endpoint, infoblox_cookie, cl_args)
    
    # If the record does not exist, response will be empty or None
    if not response or len(response) == 0:
        # Record does not exist, so create it
        data = {
            "name": md_record,
            "ipv4addrs": [{"ipv4addr": ip_address}],
            "configure_for_dns": True,
            "view": "default"  # Assuming 'default' view; adjust if necessary
        }
        # Use the infoblox_post function to create the record
        create_response = infoblox_post("record:host", infoblox_cookie, data, cl_args)
        if create_response:
            print(f"Successfully created DNS record for {md_record} with IP {ip_address}")
        else:
            print(f"Failed to create DNS record for {md_record}")
    else:
        # Record already exists
        print(f"DNS record for {md_record} already exists.")