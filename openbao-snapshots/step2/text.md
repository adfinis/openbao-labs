> **Wait for the environment setup to complete, once you see "Ready to start!" message in the shell, you can get going.**

Oh no, someone "accidentally" (wink, wink) disabled the KV secrets engine. All secrets are gone.

* `bao list kv/data/`
* `bao read kv/data/db/credentials`

It's good that we took a snapshot earlier. We can restore it.

`bao operator raft snapshot restore assets/snapshot.snap`

The KV secrets engine and all the secrets it contained should now be back. First you will need to log back in.

* `bao login -method userpass username=admin
* `bao list kv/data/`
* `bao read kv/data/db/credentials`

It's important to note that restoring a snapshot puts the server back in an earlier state. It's currently not possible to perform a partial restore. However, some secret engines, such as [KV version 2](https://openbao.org/docs/secrets/kv/kv-v2/), provide versioning capabilities.

# Snapshot automation

Okay, that was a nice save, but we can't rely on manual snapshots, right?

OpenBao does not include snapshot automation. However, the community maintains a [repository](https://github.com/openbao/openbao-snapshot-agent) that provides a collection of external tools to automate snapshots of OpenBao. In case you deploy OpenBao into production, you should definitely take a look at this.
