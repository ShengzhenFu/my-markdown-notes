
# install certbot on Ubuntu 22.04
sudo apt install python3 python3-venv libaugeas0
sudo python3 -m venv /opt/certbot/
sudo /opt/certbot/bin/pip install --upgrade pip
sudo /opt/certbot/bin/pip install certbot certbot-nginx
sudo ln -s /opt/certbot/bin/certbot /usr/bin/certbot


wget https://github.com/joohoi/acme-dns-certbot-joohoi/raw/master/acme-dns-auth.py
chmod +x acme-dns-auth.py
nano acme-dns-auth.py
#!/usr/bin/env python3
cp acme-dns-auth.py /etc/letsencrypt/
# make sure /etc/letsencrypt is empty before you run
certbot certonly --manual --agree-tos --manual-auth-hook /etc/letsencrypt/acme-dns-auth.py \
  --preferred-challenges dns --debug-challenges -d harbor.yourdomainname.com
# Please add the following CNAME record to your main DNS zone:
# _acme-challenge.harbor.yourdomainname.com CNAME 3aee1561-5f2e-45fc-b48b-9ee88207cebc.auth.acme-dns.io
# press enter continue
#Successfully received certificate.
#Certificate is saved at: /etc/letsencrypt/live/harbor.yourdomainname.com/fullchain.pem
#Key is saved at:         /etc/letsencrypt/live/harbor.yourdomainname.com/privkey.pem
#This certificate expires on 2025-xx-xx

# renew
certbot renew --dry-run
certbot renew
cp /etc/letsencrypt/live/harbor.yourdomainname.com/fullchain.pem /data/secret/cert/server.crt
cp /etc/letsencrypt/live/harbor.yourdomainname.com/privkey.pem   /data/secret/cert/server.key
docker stop nginx
docker start nginx

# check cert expire date
openssl x509 -in /etc/letsencrypt/live/harbor.yourdomainname.com/cert.pem -text -noout | grep "Not After\|Not Before"
# check by domain name
echo -n Q | openssl s_client -servername harbor.yourdomainname.com -connect harbor.yourdomainname.com:443 | openssl x509 -noout -dates
