Navigate through corrections using the Tab key. Press Enter on highlighted segments for details.
Use arrow keys to navigate between text segments. Press Enter or Space to highlight corrections. Press Escape to clear highlights.
 
> **Wait for the environment setup to complete. Once you see the "Ready to start!" message in the shell, you can get going.**

## Context 

An OpenBao server is already deployed with a Raft storage backend. A [userpass](https://openbao.org/docs/auth/userpass/) authentication method is already pre-configured. The `BAO_ADDR` environment variable has already been set for you.

You can log in with the following credentials:
> * username: admin
> * password: admin123

* `bao login -method userpass username=admin`

OpenBao is installed locally and running as a systemd service.

* `systemctl status openbao`

## Audit devices

In OpenBao, [audit devices](https://openbao.org/docs/audit/) keep a trace of all requests to OpenBao and their responses.

One audit device is already enabled on this server. It saves audit logs in a file at `/var/log/openbao/audit.log`. You can check this with the following command:

* `bao audit list -detailed`

You can also check the file itself. You will notice audit logs are stored in JSON format.

* `cat /var/log/openbao/audit.log`

As audit logs are critically important, OpenBao will stop responding to requests when no enabled audit devices can record them.
