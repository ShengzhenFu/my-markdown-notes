
# check pid of the podman container
sudo podman container inspect <your-container-name> -f '{{.State.Pid}}'

# kill the container process in Host OS
kill -9 $(sudo podman container inspect your-container-name -f '{{.State.Pid}}')

kill -9 $(netstat -antpl | grep 8080 | awk '{print $7}' | tr -d "/conmon")

# create a pod
sudo podman pod create -n webapp -p 8080:80
# create index.html to serve in container
mkdir -p /root/volume
cat >> /root/volume/index.html <<EOF
<!DOCTYPE html>
<html>
  <head>
    <title>Hello Podman</title>
  </head>
  <body>
    <h1>A message from a pod of Podman</h1>
  </body>
</html>
EOF
# attach container to the pod
sudo podman run -dt -v /root/volume:/usr/share/nginx/html --pod webapp --security-opt="seccomp=unconfined" --name hello-podman nginx

sudo podman pod ps
sudo podman pod stop webapp
sudo podman pod start webapp

# generate systemd service for the pod
# it will generate 2 unit files under ~/.config/
podman generate systemd --files --name webapp
sudo cp pod-webapp.service container-hello-podman.service /etc/systemd/system

systemctl start pod-webapp.service
systemctl enabel pod-webapp.service
systemctl is-enabled pod-webapp.service
systemctl status pod-webapp.service

# destroy all
systemctl stop pod-webapp.service
systemctl stop container-hello-podman.service
systemctl disable pod-webapp.service
systemctl disable container-hello-podman.service
rm /etc/systemd/system/pod-webapp.service 
rm /etc/systemd/system/container-hello-podman.service
systemctl daemon-reload
podman pod stop webapp
podman pod rm webapp
