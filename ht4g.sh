apt-get update -y
sudo apt update
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 80
sudo ufw allow 443
bash <(curl -Ls https://raw.githubusercontent.com/overkillzero/xrayr/main/install.sh)
read -p " NODE ID Cổng 80 Vmess: " node_id1
  [ -z "${node_id1}" ] && node_id1=0
  
read -p " NODE ID Cổng 443 Trojan: " node_id2
  [ -z "${node_id2}" ] && node_id2=0
rm -rf /etc/XrayR/ht4g.crt
rm -rf /etc/XrayR/ht4g.key
openssl req -newkey rsa:2048 -x509 -sha256 -days 365 -nodes -out /etc/XrayR/ht4g.crt -keyout /etc/XrayR/ht4g.key -subj "/C=JP/ST=Tokyo/L=Chiyoda-ku/O=Google Trust Services LLC/CN=google.com"
cd /etc/XrayR
cat >config.yml <<EOF
Log:
  Log:
  Level: none 
  AccessPath: # /etc/XrayR/access.Log
  ErrorPath: # /etc/XrayR/error.log
DnsConfigPath: # /etc/XrayR/dns.json
InboundConfigPath: # /etc/XrayR/custom_inbound.json
RouteConfigPath: # /etc/XrayR/route.json
OutboundConfigPath: # /etc/XrayR/custom_outbound.json
ConnectionConfig:
  Handshake: 4
  ConnIdle: 30
  UplinkOnly: 2
  DownlinkOnly: 4
  BufferSize: 64
Nodes:
  -
    PanelType: "V2board" 
    ApiConfig:
      ApiHost: "https://api.ht4gvpn.com"
      ApiKey: "ht4gprivatenetwork"
      NodeID1: 1
      NodeType: V2ray 
      Timeout: 30 
      EnableVless: false 
      EnableXTLS: false 
      SpeedLimit: 0
      DeviceLimit: 0
      RuleListPath: # /etc/XrayR/rulelist
    ControllerConfig:
      DisableSniffing: True
      ListenIP: 0.0.0.0 
      SendIP: 0.0.0.0 
      UpdatePeriodic: 60 
      EnableDNS: false 
      DNSType: AsIs 
      EnableProxyProtocol: false 
      EnableFallback: false 
      FallBackConfigs:  
        -
          SNI: 
          Path: 
          Dest: 80 
          ProxyProtocolVer: 0 
      CertConfig:
        CertMode: file 
        CertDomain: "HT4GVPN.COM" 
        CertFile: /etc/XrayR/ht4gvpn.crt
        KeyFile: /etc/XrayR/ht4gvpn.key
        Provider: cloudflare 
        Email: 
        DNSEnv: 
          CLOUDFLARE_EMAIL:
          CLOUDFLARE_API_KEY:
  -
    PanelType: "V2board" 
    ApiConfig:
      ApiHost: "https://api.ht4gvpn.com"
      ApiKey: "ht4gprivatenetwork"
      NodeID2: 1
      NodeType: Trojan
      Timeout: 30 
      EnableVless: false 
      EnableXTLS: false 
      SpeedLimit: 0
      DeviceLimit: 0
      RuleListPath: # /etc/XrayR/rulelist
    ControllerConfig:
      DisableSniffing: True
      ListenIP: 0.0.0.0 
      SendIP: 0.0.0.0 
      UpdatePeriodic: 60 
      EnableDNS: false 
      DNSType: AsIs 
      EnableProxyProtocol: false 
      EnableFallback: false 
      FallBackConfigs:  
        -
          SNI: 
          Path: 
          Dest: 80 
          ProxyProtocolVer: 0 
      CertConfig:
        CertMode: file 
        CertDomain: "HT4GVPN.COM" 
        CertFile: /etc/XrayR/ht4g.crt 
        KeyFile: /etc/XrayR/ht4g.key
        Provider: cloudflare 
        Email: 
        DNSEnv: 
          CLOUDFLARE_EMAIL: 
          CLOUDFLARE_API_KEY: 
EOF
sed -i "s|NodeID1:.*|NodeID: ${node_id1}|" ./config.yml
sed -i "s|NodeID2:.*|NodeID: ${node_id2}|" ./config.yml
clear
cd /root && xrayr restart && echo -e "   Cài Đặt Hoàn Tất!"
#Speedtest
curl -Lso- bench.sh | bash
