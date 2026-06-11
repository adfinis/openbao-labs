> With Integrated Storage, not all nodes are equal. It's possible that some nodes are further behind - i.e., haven't applied as many Raft logs. In a production environment, it's important that the node used for recovery has the highest AppliedIndex found in the cluster. You can check the AppliedIndex with `bao status`

[OpenBao recovery mode](https://openbao.org/docs/concepts/recovery-mode/) can be started using the `-recovery` flag. As we are in a Kubernetes environment, we need to edit the StatefulSet and add that flag to the startup command.

Stop OpenBao service
* `sudo systemctl stop openbao`

Edit the StatefulSet and add the `-recovery` flag to the startup command
* `sudo systemctl edit openbao`

Add the following snippet to the override section:

```
[Service]
ExecStart=
ExecStart=/usr/local/bin/bao server -config=/etc/openbao/openbao.hcl -recovery
```

Scale OpenBao StatefulSet up again:
* `sudo systemctl start openbao`

Now the logs should show OpenBao is started in recovery mode:

* `journalctl -eu openbao`

```bash
==> OpenBao server configuration:

               Seal Type: static
       Static KMS Key ID: 20260302-1
         Cluster Address: https://openbao-0.openbao-internal:8201
              Go Version: go1.25.7
               Log Level: trace
           Recovery Mode: true # This line
                 Storage: raft
                 Version: OpenBao v2.0.0-HEAD, built 2026-04-15T08:16:37Z
             Version Sha: 21db149765f9b3db983557e40c006bed37e7d8f6
```
