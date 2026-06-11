> **Wait for the environment setup to complete. Once you see the "Ready to start!" message in the shell, you can get going. It takes 1–2 minutes for the preparation to complete.**

## Context 

An OpenBao server is already deployed with a Raft storage backend. A [userpass](https://openbao.org/docs/auth/userpass/) authentication method is already preconfigured. The `BAO_ADDR` environment variable has already been set for you.

You can log in with the following credentials:
> * username: admin
> * password: admin123

* `bao login -method=userpass username=admin`

OpenBao is installed locally and running as a systemd service.

* `systemctl status openbao`

## Get recovery keys

In recovery mode, we will require OpenBao recovery keys. As this OpenBao server was deployed with [self-initialization](https://openbao.org/docs/configuration/self-init/), we can get the initial set of recovery keys from `sys/rotate/recovery/init`. As this is a lab environment, we will request a single key share. In production you would likely have multiple shares.

Get the recovery key from OpenBao:
* `bao write sys/rotate/recovery/init secret_shares=1 secret_threshold=1`

```bash
Key                      Value
---                      -----
backup                   false
complete                 true
# SAVE THIS
keys                     [9c5348cbeef4f56fb3618c9ba9b71496ab5c30bff7efea73499bf4ace5fb00ce]
keys_base64              [nFNIy+709W+zYYybqbcUlqtcML/37+pzSZv0rOX7AM4=]
n                        1
pgp_fingerprints         <nil>
t                        1
verification_nonce       n/a
verification_required    false
``` 

Note this key and keep it at hand, as we will need it later.
