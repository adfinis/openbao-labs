> **Wait for the environment setup to complete. Once you see the "Ready to start!" message in the shell, you can get going. It takes ~15 seconds for the preparation to complete.**

Something broke, and our cluster doesn't accept requests anymore.

* `bao status` 
* `bao secrets list` 

We can also try issuing commands directly to the pod

* `kubectl exec -n openbao openbao-0 -- bao secrets list`

The error message here tells us that openbao-0 is not the cluster leader (active node) anymore.
```
Defaulted container "openbao" out of: openbao, create-missing-files (init)
Error listing secrets engines: Error making API request.

URL: GET http://127.0.0.1:8200/v1/sys/mounts
Code: 500. Errors:

* local node not active but active cluster node not found
command terminated with exit code 2
```

Let's check the pods :

* `kubectl get pods -n openbao`

It seems `openbao-2` is gone and `openbao-1` is not posting a `ready` status.
```
NAME        READY   STATUS    RESTARTS   AGE
openbao-0   1/1     Running   0          4m30s
openbao-1   0/1     Running   0          67s
```

Let's check the logs of `openbao-0`:

* `kubectl logs -n openbao openbao-0`

You should see something similar. Those error messages indicate that leader election is failing, as both openbao-1 and openbao-2 are not part of the cluster anymore.
``` 
[WARN]  storage.raft: Election timeout reached, restarting election
[INFO]  storage.raft: entering candidate state: node="Node at openbao-0.openbao-internal:8201 [Candidate]" term=4
[ERROR] storage.raft: failed to make requestVote RPC: target="{Voter openbao-1 openbao-1.openbao-internal:8201}" error="dial tcp 192.168.0.17:8201: connect: connection refused" term=4
[ERROR] storage.raft: failed to make requestVote RPC: target="{Voter openbao-2 openbao-2.openbao-internal:8201}" error="dial tcp: lookup openbao-2.openbao-internal on 10.96.0.10:53: no such host" term=4
[INFO]  storage.raft: pre-vote campaign failed, waiting for election timeout: term=4 tally=1 refused=2 votesNeeded=2
```

Let's check the logs of `openbao-1`:

* `kubectl logs -n openbao openbao-1`

The logs of openbao-1 indicate that it's failing to join the cluster.
```
[ERROR] core: failed to retry join raft cluster: retry=2s err="failed to get raft challenge"
[INFO]  core: security barrier not initialized
[INFO]  core.autoseal: seal configuration missing, not initialized
[INFO]  core: security barrier not initialized
[INFO]  core: attempting to join possible raft leader node: leader_addr=http://openbao-internal.openbao.svc.cluster.local:8200
[ERROR] core: failed to get raft challenge: leader_addr=http://openbao-internal.openbao.svc.cluster.local:8200
  error=
  | error during raft bootstrap init call: Error making API request.
  | 
  | URL: PUT http://openbao-internal.openbao.svc.cluster.local:8200/v1/sys/storage/raft/bootstrap/challenge
  | Code: 503. Errors:
  | 
  | * Vault is sealed
  
[ERROR] core: failed to retry join raft cluster: retry=2s err="failed to get raft challenge"
```

In the next step, we are going to see how we can recover from this state.
