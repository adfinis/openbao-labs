Oh no, something broke and OpenBao is sealed and won't respond to requests anymore.

* `bao status`

```
Key                      Value
---                      -----
Seal Type                static
Recovery Seal Type       shamir
Initialized              true
Sealed                   true
```

* `systemctl status openbao`

```
[INFO]  core: vault is sealed
```

Here you can try solving it yourself, or move to the next step and follow along.
