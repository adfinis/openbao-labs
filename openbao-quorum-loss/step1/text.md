> **Wait for the environment setup to complete. Once you see the "Ready to start!" message in the shell, you can get going. It takes 1-2 minutes for the preparation to complete.**

## Context 

A 3-node OpenBao cluster is already deployed on Kubernetes in the `openbao` namespace. 

* `kubectl get pods -n openbao`

```
NAME        READY   STATUS    RESTARTS   AGE
openbao-0   1/1     Running   0          2m2s
openbao-1   1/1     Running   0          93s
openbao-2   1/1     Running   0          80s
```

A [userpass](https://openbao.org/docs/auth/userpass/) authentication method is already pre-configured. The `BAO_ADDR` environment variable has already been set for you.

You can log in with the following credentials:
> * username: admin
> * password: admin123

* `bao login -method userpass username=admin`

* `bao operator raft list-peers`

```
Node         Address                            State       Voter
----         -------                            -----       -----
openbao-0    openbao-0.openbao-internal:8201    leader      true
openbao-1    openbao-1.openbao-internal:8201    follower    true
openbao-2    openbao-2.openbao-internal:8201    follower    true
```

When running in HA mode, each node can have two states: `leader` or `follower`. At any time only one node can be a leader (active) and process the requests. Followers (standby) will redirect all requests to the leader node. Standby nodes will only replicate data from the current leader. If the active node fails, a new leader is elected from the nodes that are left.

## Raft Quorum

In a Raft cluster, a quorum requires at least `(n+1)/2` members. This directly determines the failure tolerance of a cluster.

For example :

* For a 3-node cluster (our scenario)
  * Quorum is 2 (`(3+1)/2=2`).
* Failure tolerance is 1 node.
* For a 5-node cluster: 
  * Quorum is 3 (`(5+1)/2=3`).
  * Failure tolerance is 2.

If at any point quorum is lost, OpenBao will not be able to process requests anymore.

You can find more information about [Raft/integrated storage in the project documentation](https://openbao.org/docs/internals/integrated-storage/).
