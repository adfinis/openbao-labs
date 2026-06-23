export BAO_ADDR=$(sed 's/PORT/30200/g' /etc/killercoda/host)

bao login -method=userpass username=admin password=admin123
bao namespace create lab-b

for id in $(bao list -format=json sys/raw/core/namespaces | jq -r '.[]');do
  if [[ $(bao read -field=value sys/raw/core/namespaces/$id | jq -r '.path') == "lab-b/" ]]; then
    bao write sys/raw/core/namespaces/$id namespace=borked
  fi
done;

systemctl restart openbao

echo done > /tmp/ready
