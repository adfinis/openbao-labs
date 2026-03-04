export BAO_HELM_VERSION=0.25.6
export BAO_CLI_VERSION=2.5.1

wget https://github.com/openbao/openbao/releases/download/v$BAO_CLI_VERSION/bao_${BAO_CLI_VERSION}_Linux_x86_64.tar.gz
tar xzf bao_${BAO_CLI_VERSION}_Linux_x86_64.tar.gz
mv bao /usr/local/bin/

# Create unseal key
openssl rand -out /root/assets/unseal-20260302-1.key 32
kubectl create secret generic openbao-unseal-key --from-file=unseal-20260302-1.key=/root/assets/unseal-20260302-1.key

# Deploy OpenBao
helm repo add openbao https://openbao.github.io/openbao-helm
helm repo update
helm install openbao openbao/openbao -f /root/assets/chart-values.yaml --version $BAO_HELM_VERSION
kubectl apply -f /root/assets/node-port.yaml
kubectl wait --for=condition=Ready pod/openbao-0
echo done > /tmp/ready
