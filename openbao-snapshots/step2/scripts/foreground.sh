echo Preparing the environment...
export BAO_ADDR=$(sed 's/PORT/30200/g' /etc/killercoda/host)
bao login -method userpass username=admin password=admin123
bao secrets disable kv
echo Ready to start!
