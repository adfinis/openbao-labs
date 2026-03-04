To interact with OpenBao, we need first to set the `BAO_ADDR` environment variable.
This variable tells the OpenBao CLI with which server we want to interact.

Open up a new terminal tab and set the `BAO_ADDR` environment variable to point to our dev server we started in the previous step.
``` 
export BAO_ADDR='http://127.0.0.1:8200'
```

You can now use the `bao status` command to get some information about our server.
You don't need to be authenticated to run `bao status` and it will provide you some information like the sealing method, the state, the version, storage type, etc.

```
$ bao status
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    1
Threshold       1
Version         2.5.1
Build Date      2026-02-23T17:30:29Z
Storage Type    inmem
Cluster Name    vault-cluster-b0a144ae
Cluster ID      02e66f01-959f-15cd-3a2c-74aa5bede541
HA Enabled      false
```

Another way you can get information about OpenBao state is by querying the `sys/health` endpoint of the API.
This will provide you similar information as `bao status` but has the added benefit of returning an HTTP status code.
This [HTTP status code directly provides information about the OpenBao node state](https://openbao.org/api-docs/system/health/#read-health-information) and could be leveraged as part of a load balancer setup.

```
$ curl -i -s http://127.0.0.1:8200/v1/sys/health     

HTTP/1.1 200 OK
Cache-Control: no-store
Content-Type: application/json
Strict-Transport-Security: max-age=31536000; includeSubDomains
Date: Fri, 27 Feb 2026 09:31:02 GMT
Content-Length: 294

{"initialized":true,"sealed":false,"standby":false,"performance_standby":false,"replication_performance_mode":"disabled","replication_dr_mode":"disabled","server_time_utc":1772184662,"version":"2.5.1","cluster_name":"vault-cluster-b0a144ae","cluster_id":"02e66f01-959f-15cd-3a2c-74aa5bede541
```
