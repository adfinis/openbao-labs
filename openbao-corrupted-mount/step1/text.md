> **Wait for the environment setup to complete. Once you see the "Ready to start!" message in the shell, you can get going.**

## Context 

An OpenBao server is already deployed with a Raft storage backend. A [userpass](https://openbao.org/docs/auth/userpass/) authentication method is already pre-configured. The `BAO_ADDR` environment variable has already been set for you.

You can log in with the following credentials:
> * username: admin
> * password: admin123

* `bao login -method=userpass username=admin`

OpenBao is installed locally and running as a systemd service.

* `systemctl status openbao`

There is also a namespace `lab-a` already provisioned.

* `bao namespace list`
