BAO_ADDR=$(sed 's/PORT/30200/g' /etc/killercoda/host)
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" $BAO_ADDR/v1/sys/health)
if [ "$STATUS_CODE" -ne 200 ]; then
  exit 1
fi
