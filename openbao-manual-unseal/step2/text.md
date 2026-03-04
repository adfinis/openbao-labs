In this scenario, OpenBao is deployed on Kubernetes. Check the pods by running `kubectl get pods`. As it's not yet initialized and unsealed, the pod will not report as "Ready".

Our first step will be to initialize the OpenBao server. As we are running on Kubernetes, we cannot directly interact with OpenBao from our shell and need to pass the `bao operator init` command to the pod : 

`kubectl exec openbao-0 -ti -- bao operator init -key-shares=1 -key-threshold=1`

This will give us a set of unseal keys and an initial root token. We can now unseal OpenBao.

``` 
Unseal Key 1: ...

Initial Root Token: ...
```

By default OpenBao will generate 5 unseal keys with a threshold of 3. Meaning we would need to provide at least 3 keys to unseal it.

Because with used the flags `-key-shares=1 -key-threshold=1`, OpenBao a generates a single key (`key-shares=1`) and we need to submit only one key (`key-threshold=1`) to unseal OpenBao. This is fine for test environment but in production you'll want multiple key shares.

In the real world scenario, we would also need to securely store those keys for latter retrieval.
