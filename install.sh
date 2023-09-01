bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install --beta

json=$(curl -s https://raw.githubusercontent.com/debug-ing/xray-reality/master/config.json)

ip=$(curl -s ifconfig.me)
uuid=$(xray uuid)
host=fast.com
url="vless://$uuid@$ip:443?type=tcp&security=none&headerType=http&host=$host&path=/#config"

config=$(echo "$json" | jq \
    --arg uuid "$uuid" \
    --arg host "$host" \
    '.inbounds[0].settings.clients[0].id = $uuid |
     .inbounds[0].streamSettings.tcpSettings.header.request.headers.Host = ["'$host'"]')
echo "$config" | sudo tee /usr/local/etc/xray/config.json >/dev/null

sudo service xray restart

echo "$url"

qrencode -s 120 -t ANSIUTF8 "$url"
qrencode -s 50 -o qr.png "$url"

exit 0