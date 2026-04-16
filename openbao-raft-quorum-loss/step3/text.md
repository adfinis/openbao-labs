**Normally, the first thing to do in such a situation would be to wipe clean all OpenBao data and [restore from a snapshot](https://openbao.org/docs/commands/operator/raft/#snapshot-restore).**

**The recovery using `peers.json` that we are going to explore here should only be used when there are no other options available, as it might cause inconsistencies with the data. It's, however, useful to know about.**

## Manual recovery using peers.json

> When performing this procedure, it's important to carefully evaluate which nodes to recover and which nodes to wipe the data from. Otherwise you might loose data.

The first step is to determine which of our nodes contains the latest data.

In our case, it looks like only `openbao-0` comes up as ready. It's also the node containing the oldest data set:

* `kubectl get pods -n openbao`
* `kubectl exec -n openbao openbao-0 -ti -- ls -al /openbao/data`
* `kubectl exec -n openbao openbao-1 -ti -- ls -al /openbao/data`

We are going to scale down the StatefulSet so that only `openbao-0` is running:

* `kubectl scale sts -n openbao openbao --replicas=1`

We will create the file at `/openbao/data/raft/peers.json` with the following entry:

* **id**: OpenBao node ID
* **address**: Address of the node (here we leverage Kubernetes internal DNS, but in other deployments we might use the IP)
* **non_voter**: We want that node to join as a voter (and even become a leader in that case).

```json
[
  {
    "id": "openbao-0",
    "address": "openbao-0.openbao-internal.openbao.svc.cluster.local:8201",
    "non_voter": false
  }
]
```

This file explicitly tells OpenBao which nodes are part of the cluster. In this case, this allows OpenBao to start and establish quorum with a single node.

The file is already pre-filled and stored at `/root/assets/peers.json`. We can just copy it to the pod:

* `kubectl cp /root/assets/peers.json -n openbao openbao-0:/openbao/data/raft/peers.json`

Now, we are going to delete all data from the other nodes. To achieve this, we can directly delete the PVC (note: `data-openbao-2` is already deleted):

* `kubectl delete pvc -n openbao data-openbao-1`

Next we want to restart `openbao-0` so that it comes up healthy again:

* `kubectl rollout restart sts -n openbao openbao`

Once the pod has restarted, OpenBao should be up and running again, ready to process request:

* `kubectl get pods -n openbao`

```
NAME        READY   STATUS    RESTARTS   AGE
openbao-0   1/1     Running   0          10s
```

* `bao status`

Let's check the logs:

* `kubectl logs -n openbao openbao-0`

We can see in the logs that during the startup, the node initiated a recovery due to the `peers.json` file. Once the recovery is done, OpenBao will delete the `peers.json` file:
```
[INFO]  storage.raft: raft recovery initiated: recovery_file=peers.json
[INFO]  storage.raft: raft recovery found new config: config="{[{Voter openboa-0 openboa-0.openbao.svc.cluster.local:8201}]}"
[INFO]  storage.raft: snapshot restore progress: id=bolt-snapshot last-index=45 last-term=3 size-in-bytes=0 read-bytes=0 percent-complete="NaN%"
[INFO]  storage.raft: raft recovery deleted peers.json
```

We can also verify that it's now a single-node "cluster":

* `bao operator raft list-peers`

```
Node         Address                                     State     Voter
----         -------                                     -----     -----
openbao-0    openbao-0.openbao.svc.cluster.local:8201    leader    true
```

It's not over; we also want the other two nodes to join the cluster back. As they have no data anymore, we can simply scale up the StatefulSet again, and they will join the cluster gracefully:

* `kubectl scale sts -n openbao openbao --replicas=3`

Let's check the cluster members once the pods are running:

* `kubectl get pods -n openbao`
* `bao operator raft list-peers`

```
Node         Address                                     State       Voter
----         -------                                     -----       -----
openbao-0    openbao-0.openbao.svc.cluster.local:8201    leader      true
openbao-1    openbao-1.openbao-internal:8201             follower    true
openbao-2    openbao-2.openbao-internal:8201             follower    true
```

The recovery with `peers.json` is also detailed in [the project documentation](https://openbao.org/docs/concepts/integrated-storage/#manual-recovery-using-peersjson).
