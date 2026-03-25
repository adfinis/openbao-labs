Now that our SecretStore resource is ready, we can create an [ExternalSecret](https://external-secrets.io/latest/api/externalsecret/) resource to fetch the secret.

A prefilled manifest is saved at `/root/assets/externalsecrets.yaml`. You can use the editor tab to edit.

We need to specify:
* A reference to the SecretsStore we created previously:
```yaml
secretStoreRef:
    name: "openbao-secret-store"
    kind: "SecretStore"
```
* The target Kubernetes secret:
```yaml
target:
    # the name of the target Kubernetes secret
    name: my-app-secret
```
* The secret we want to fetch from OpenBao:
```yaml
  data:
      # the key in the target Kubernetes secret where the value will be stored
    - secretKey: my-secret
      remoteRef:
        # path to the secret in OpenBao. We can omit the usual `kv/data/`{{}} here.
        key: openbao-eso-lab
        # the key of the value we want to fetch
        property: secret
```

Here is the full example (also stored at `/root/assets/externalsecrets.yaml`):

```yaml
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: "my-external-secret"
  namespace: "lab"
spec:
  # the SecretStore to use for fetching the secret.
  secretStoreRef:
    name: "openbao-secret-store"
    kind: "SecretStore"
  refreshPolicy: Periodic
  # refresh every 15 minutes.
  refreshInterval: "15m"
  target:
    # the name of the target Kubernetes secret
    name: my-app-secret
  data:
      # the key in the target Kubernetes secret where the value will be stored
    - secretKey: my-secret
      remoteRef:
        # path to the secret in OpenBao. We can omit the usual `kv/data/`{{}} here.
        key: openbao-eso-lab
        # the key of the value we want to fetch
        property: secret
```

Once ready, we can create the resource with `kubectl apply -f /root/assets/externalsecrets.yaml`.

If all goes well, External Secrets should fetch and create the Kubernetes secrets after a few seconds.

* `kubectl get secret -n lab`

```bash
NAME            TYPE     DATA   AGE
my-app-secret   Opaque   1      8s
``` 

In case of an issue, we can also check the state of the ExternalSecret resource.

* `kubectl describe externalsecret my-external-secret -n lab`

```bash
...
Type    Reason   Age   From              Message
----    ------   ----  ----              -------
Normal  Created  38s   external-secrets  secret created
```
