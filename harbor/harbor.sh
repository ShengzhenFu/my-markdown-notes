
wget https://github.com/goharbor/harbor/releases/download/v2.11.0/harbor-offline-installer-v2.11.0.tgz
tar -xzvf harbor-offline-installer-v2.11.0.tgz
cd harbor
# update harbor.yml on below lines
######################################
hostname: harbor.yourdomainname.com
http:
  port: 80
https:
  port: 443
  certificate: /etc/letsencrypt/live/harbor.yourdomainnamecom/fullchain.pem
  private_key: /etc/letsencrypt/live/harbor.yourdomainname.com/privkey.pem
harbor_admin_password: pAssword12345
######################################
# use Letsencrypt.sh to generate certificates
# generate docker compose file and configs
./prepare
# start Harbor
docker compose up -d
# If you could find all the containers below are running
NAMES                            STATUS                 PORTS
nginx                            Up 5 weeks (healthy)   0.0.0.0:80->8080/tcp, :::80->8080/tcp, 0.0.0.0:443->8443/tcp, :::443->8443/tcp
harbor-jobservice                Up 5 weeks (healthy)
harbor-core                      Up 5 weeks (healthy)
harbor-db                        Up 5 weeks (healthy)
redis                            Up 5 weeks (healthy)
harbor-portal                    Up 5 weeks (healthy)
registryctl                      Up 5 weeks (healthy)
registry                         Up 5 weeks (healthy)
harbor-log                       Up 5 weeks (healthy)   127.0.0.1:1514->10514/tcp 

# create A record in CloudFlare to resolve harbor.yourdomainname.com to the IP address of current server
