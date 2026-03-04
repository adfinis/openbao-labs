Now that the configuration include our unseal key, we can deploy OpenBao using Helm. The repository has already been set up for you so you can directly use `helm install openbao openbao/openbao -f /root/assets/chart-values.yaml --version 0.25.6`

OpenBao should now get deployed, we can check the pod status `kubectl get pods`. As with Shamir, the pod won't report as ready until OpenBao has been initialized.

(Please wait until the pod report status as "Running" like below to continue)
```
NAME        READY   STATUS    RESTARTS   AGE
openbao-0   0/1     Running   0          3m
```

We can see in the pod logs (`kubectl logs openbao-0`) that it's trying to unseal but we first need to initialize OpenBao at least once.

```
2026-03-02T15:09:18.465Z [INFO]  core: stored unseal keys supported, attempting fetch
2026-03-02T15:09:18.466Z [WARN]  failed to unseal core: error="stored unseal keys are supported, but none were found: is the server initialized?"
2026-03-02T15:09:20.299Z [INFO]  core: security barrier not initialized
2026-03-02T15:09:20.299Z [INFO]  core.autoseal: seal configuration missing, not initialized
```
