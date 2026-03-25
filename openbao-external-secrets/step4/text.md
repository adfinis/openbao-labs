ESO is already deployed in the `external-secrets` namespace. You can check it with

* `kubectl get pods -n external-secrets`

As [per ESO documentation](https://external-secrets.io/latest/provider/openbao/), we need to use the existing Vault provider to integrate ESO with OpenBao.

But first we need to create the Kubernetes namespace and service we defined previously.

* `kubectl create namespace lab`
* `kubectl create serviceaccount my-app -n lab`

Now we can create the [SecretStore](https://external-secrets.io/latest/api/secretstore/) resource.
A pre-filled manifest is saved at `/root/assets/secretstore.yaml`. You can use the editor tab to edit it.

We have to specify :
* The server address (you can use `echo $BAO_ADDR` to find it out)
```yaml
      # run `echo $BAO_ADDR`{{}} to get the server address 
      server: <server-address>
```
* The path to the KV secrets engine: `path: "kv"`
```yaml
 # path to the KV secrets engine
      path: "kv"
```
* The auth method mount path: `mountPath: "kubernetes"`
```yaml
      auth:
        kubernetes:
          # path of the Kubernetes auth method
          mountPath: "kubernetes"
```
* The role to use: `role: "lab"`
```yaml
          # role to use for the Kubernetes auth method
          role: "lab"
```
* The service account to use: `name: "my-app"`
```yaml
          serviceAccountRef:
            # service account to use for authentication
            name: "my-app"
```

You can see the full example below :
 
```yaml
apiVersion: external-secrets.io/v1
kind: SecretStore
metadata:
  name: openbao-secret-store
  namespace: lab
spec:
  provider:
    vault:
      # run `echo $BAO_ADDR` to get the server address 
      server: <server-address>
      # path to the KV secrets engine
      path: "kv"
      # version of the KV secrets engine
      version: v2"
      auth:
        kubernetes:
          # path of the Kubernetes auth method
          mountPath: "kubernetes"
          # role to use for the Kubernetes auth method
          role: "lab"
          serviceAccountRef:
            # service account to use for authentication
            name: "my-app"
```

Once ready, we can create the resource :
* `kubectl apply -f /root/assets/secretstore.yaml`

We can also check the state of the SecretStore resource : 
* `kubectl describe -n lab secretstore openbao-secret-store`

```bash
...
Events:
  Type    Reason  Age              From          Message
  ----    ------  ----             ----          -------
  Normal  Valid   6s (x2 over 6s)  secret-store  store validated
```
