Now we need to update the OpenBao configuration to use the static key. We will update this through the Helm chart values. The file is `/root/assets/chart-values.yaml`. You can switch to the editor tab to edit the file.

You'll notice the volume is already configured. So no need to update this unless you used a different secret name.
What we want to update is the `seal` stanza. Here we need to set the `current_key_id` and `current_key` which is the path to the key (the path is relative to the pod context).

```yaml
injector:
  enabled: false
server:
  volumes:
    - name: static-unseal-key
      secret:
        secretName: openbao-unseal-key
  volumeMounts:
    - name: static-unseal-key
      mountPath: /bao/unseal
  standalone:
    config: |
      listener "tcp" {
        tls_disable = 1
        address = "[::]:8200"
        cluster_address = "[::]:8201"
      }
      storage "file" {
        path = "/openbao/data"
      }
      # Update this part
      seal "static" {
        current_key_id = "20260302-1"
        current_key = "file:///bao/unseal/unseal-20260302-1.key"
      }

```
