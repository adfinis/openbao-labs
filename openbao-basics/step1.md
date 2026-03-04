OpenBao is a single Go binary that can be run in different modes (agent, server, dev, ...).

Let's try to run OpenBao in dev mode.

```
bao server -dev
```

The `-dev` flags tell OpenBao to start in dev mode. In this mode, all OpenBao data is stored in memory and deleted once the process is stopped.
This mode is useful to quickly try out things in a safe environment.

In dev mode, OpenBao will generate an unseal key and root token for you.

```
The unseal key and root token are displayed below in case you want to
seal/unseal the Vault or re-authenticate.

Unseal Key: ...
Root Token: ...
```

You can use those to interact with OpenBao.
