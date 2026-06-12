#This lab relies on a bug that exists only in OpenBao <2.5.x
export BAO_CLI_VERSION=2.5.4

wget https://github.com/openbao/openbao/releases/download/v$BAO_CLI_VERSION/bao_${BAO_CLI_VERSION}_Linux_x86_64.tar.gz
tar xzf bao_${BAO_CLI_VERSION}_Linux_x86_64.tar.gz
mv bao /usr/local/bin/

setcap cap_ipc_lock=+ep /usr/local/bin/bao

sudo useradd --system --home /etc/openbao --shell /bin/false openbao
mkdir -p /etc/openbao/unseal /opt/openbao/data /var/log/openbao
chown -R openbao:openbao /var/log/openbao /etc/openbao /opt/openbao
sudo chmod -R 750 /etc/openbao /opt/openbao /var/log/openbao

# unseal key
openssl rand -out /etc/openbao/unseal/unseal-20260302-1.key 32

mv /root/assets/openbao.hcl /etc/openbao/
mv /root/assets/openbao.service /etc/systemd/system/openbao.service

sudo systemctl daemon-reload
sudo systemctl enable --now openbao

sleep 30s

export BAO_ADDR=$(sed 's/PORT/30200/g' /etc/killercoda/host)
bao login -method=userpass username=admin password=admin123
bao write -format=json sys/rotate/recovery/init secret_shares=1 secret_threshold=1 | jq -r '.data.keys[0]'> /root/assets/recovery-key.txt
bao namespace create lab-a

echo done > /tmp/ready
