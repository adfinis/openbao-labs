We can now explore OpenBao storage through recovery mode.

As usual, let's set the `BAO_TOKEN` environment variable.

* `export BAO_TOKEN=<recovery-token>`

Now we should be able to send a request to `sys/raw`

* `bao list sys/raw`

## Explore `sys/raw`

In recovery mode, only `sys/raw` will be available. The main purpose of recovery mode is to allow direct access to OpenBao storage when the service is failing to start.

For example, we review the `admin` user in the userpass auth method.

```bash
$ bao list sys/raw/auth
Keys
----
f79596dc-7f7f-cdd0-7fbc-8ed6d818c728/

$ bao list sys/raw/auth/f79596dc-7f7f-cdd0-7fbc-8ed6d818c728
Keys
----
user/

$ bao list sys/raw/auth/f79596dc-7f7f-cdd0-7fbc-8ed6d818c728/user
Keys
----
admin

$ bao read sys/raw/auth/f79596dc-7f7f-cdd0-7fbc-8ed6d818c728/user/admin
Key      Value
---      -----
value    {"token_bound_cidrs":null,"token_explicit_max_ttl":0,"token_max_ttl":0,"token_no_default_policy":false,"token_num_uses":0,"token_period":0,"token_policies":["admin"],"token_type":0,"token_ttl":0,"token_strictly_bind_ip":false,"PasswordHash":"JDJhJDEwJGlacHFPMkNGUkZ1NXJKM0txeE9LbS5LV0RHcEIzdXFpakhtY0xvbmFINnlrNGRQSUhoa2pD","Policies":null,"TTL":0,"MaxTTL":0,"BoundCIDRs":null}
```

We can also select only the JSON value field and pipe it to `jq` for better readability.

* `bao read -field=value sys/raw/auth/bb72f4df-d421-06f4-7760-ebffb749d973/user/admin | jq`

```bash
{
  "token_bound_cidrs": null,
  "token_explicit_max_ttl": 0,
  "token_max_ttl": 0,
  "token_no_default_policy": false,
  "token_num_uses": 0,
  "token_period": 0,
  "token_policies": [
    "admin"
  ],
  "token_type": 0,
  "token_ttl": 0,
  "token_strictly_bind_ip": false,
  "PasswordHash": "JDJhJDEwJFM4cDlaVHdZTlBrdTJxenFINnF4R3VML0tqcUF4ZE4xL2ZoZ1V6cFpleFlzYlE5NkllUlZL",
  "Policies": null,
  "TTL": 0,
  "MaxTTL": 0,
  "BoundCIDRs": null
}
```

We can also take a look at the audit device configuration. That could be useful in the event of an audit device failure:

* `bao read -field=value sys/raw/core/audit | jq`

```bash
{
  "type": "audit",
  "entries": [
    {
      "table": "audit-config",
      "path": "to-file/",
      "type": "file",
      "description": "File audit device",
      "uuid": "d8f4794c-45f8-7e5f-e926-260be7602638",
      "backend_aware_uuid": "",
      "accessor": "audit_file_065ef3a2",
      "config": {},
      "options": {
        "file_path": "/var/log/openbao/audit.log"
      },
      "local": false,
      "seal_wrap": false,
      "namespace_id": "root"
    }
  ]
}
```

In a catastrophic scenario, you might need to edit or delete some keys. In a production environment, it's recommended to always have a snapshot ready before performing any operation in recovery mode.

Feel free to keep exploring recovery mode.


# Revert service

Once we are done with recovery mode, we can revert the systemd unit back to its original config:

* `sudo systemctl revert openbao`
* `sudo systemctl restart openbao`
