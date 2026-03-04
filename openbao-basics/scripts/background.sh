export BAO_VERSION=2.5.1
wget https://github.com/openbao/openbao/releases/download/v$BAO_VERSION/bao_${BAO_VERSION}_Linux_x86_64.tar.gz
tar xzf bao_${BAO_VERSION}_Linux_x86_64.tar.gz
mv bao /usr/local/bin/
echo done > /tmp/ready
