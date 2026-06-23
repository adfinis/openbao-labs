A new namespace `lab-b` was created, but the cluster crashed during the process. This ended up corrupting the mount table of the OpenBao storage database.
OpenBao is now unable to start correctly:

* `journalctl -eu openbao`

```
[ERROR] core: post-unseal setup failed: error="error loading initial namespaces: failed to decode namespace fba3de26-98c7-bfb1-b6ec-9b37da078548 (page 0 / index 1): invalid character 'b' looking for beginning of value"
[ERROR] core: failed to list entries in core/leader: error="context canceled"
```

The server recovery key has been saved for you in `/root/assets/recovery-key.text`.

With this, you can now try to solve the issue by yourself or follow along in the next step. (Hint: this involves [recovery mode](https://openbao.org/docs/concepts/recovery-mode/))
