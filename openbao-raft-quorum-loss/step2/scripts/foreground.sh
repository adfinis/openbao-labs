echo Preparing the environment...
while [ ! -f /tmp/ready ]; do sleep 1; done
sleep 15s
export BAO_ADDR=$(sed 's/PORT/30200/g' /etc/killercoda/host)
echo Ready to start!
