kubectl scale sts -n openbao openbao --replicas=1
kubectl delete pvc -n openbao data-openbao-1 data-openbao-2
kubectl scale sts -n openbao openbao --replicas=2
echo done > /tmp/ready
