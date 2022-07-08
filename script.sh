#!/bin/bash
#/bin/script.sh

#DuckDNS
ddns_domain=hannahpapeles
ddns_token=473fba06-f1d5-4dc8-850d-e0fbba0748f4
ddns_update=$(curl -fsSL https://duckdns.org/update/{$ddns_domain}/{$ddns_token}/)
echo
echo DDNS Update: $ddns_update

#UPnP
upnpc -s > upnp.txt
lan_ip=$(cat upnp.txt | grep ^"Local LAN ip address" | cut -c24-)
wan_ip=$(cat upnp.txt | grep ^ExternalIPAddress | cut -c21-)
public_ip=$(host myip.opendns.com resolver1.opendns.com | grep ^"myip.opendns.com has address" | cut -c30-)
router_ip=$(cat upnp.txt | grep ^" desc: http://" | cut -c15-25)
igd_port=$(cat upnp.txt | grep ^" desc: http://" | cut -c27-30)
igd_desc_url=$(cat upnp.txt | grep ^" desc:" | cut -c8-)
igd_control_url=$(cat upnp.txt | grep ^"Found a (not connected?) IGD : " | cut -c32-)
ports=(23 80 81 82 443)

echo
echo Lan Ip: $lan_ip
echo Wan Ip: $wan_ip
echo Public Ip: $public_ip
echo Router Ip: $router_ip
echo IGD Port: $igd_port
echo IGD Desc Url: $igd_desc_url
echo IGD Control Url: $igd_control_url
echo Puertos: ${ports[@]}
echo

for i in "${ports[@]}"
do
    upnpc -u  $igd_desc_url -d $i TCP > /dev/null
    upnpc -u  $igd_desc_url -d $i UDP > /dev/null
    upnpc -u  $igd_desc_url -a $lan_ip $i $i TCP > /dev/null
done

upnpc -l | sed '1,16d' | sed '$d'

# for i in "${ports[@]}"
# do
#     external_port=$i
#     internal_port=$i
#     upnpc -u  $igd_desc_url -d $internal_port TCP > /dev/null
#     upnpc -u  $igd_desc_url -d $internal_port UDP > /dev/null
#     upnpc -u  $igd_desc_url -a $lan_ip $internal_port $external_port TCP > /dev/null
# done

# external_port=23
# internal_port=23
# upnpc -u  $igd_desc_url -d $internal_port TCP > /dev/null
# upnpc -u  $igd_desc_url -d $internal_port UDP > /dev/null
# upnpc -u  $igd_desc_url -e "SSH mapping for ERP" -a $lan_ip $internal_port $external_port TCP > /dev/null

