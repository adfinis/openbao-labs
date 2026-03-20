> **Wait for the environment setup to complete, once you see "Ready to start!" message in the shell, you can get going.**

## Context

An OpenBao server is deployed in the `openbao` namespace. A [userpass](https://openbao.org/docs/auth/userpass/) authentication method is already pre-configured. The `BAO_ADDR` environment variable has already been set for you.

You can log in with the following credentials:
> * username : admin
> * password : admin123

* `bao login -method userpass username=admin`

You'll notice that a KV secrets engine is already enabled.

* `bao secrets list`
