OpenBao provides an HTTP API. So anything you can do with CLI, you can also do with a `curl` request to the [corresponding API endpoint](https://openbao.org/api-docs/). When working directly with the API, you will need to pass the token with the header `X-Vault-Token`

For example to list policies we would do :

```
curl -X LIST --header "X-Vault-Token: ..." http://127.0.0.1:8200/v1/sys/policies/acl
```

As a response, we will get a JSON that can be parsed with `jq` for example :

```
$ curl -s -X LIST --header "X-Vault-Token: s..." http://127.0.0.1:8200/v1/sys/policies/acl | jq
{
  "request_id": "60fda7c2-66e0-b726-e932-8f2c7bd21b81",
  "lease_id": "",
  "renewable": false,
  "lease_duration": 0,
  "data": {
    "keys": [
      "default",
      "root"
    ]
  },
  "wrap_info": null,
  "warnings": null,
  "auth": null
}
```

Try it out with different [endpoints of the API](https://openbao.org/api-docs/) !

A cool tip to easily get the full `curl` command is to use the `--output-curl-string` flag of the OpenBao cli. This works for most commands and will output the corresponding `curl` command.

For example :

```
$ bao policy read -output-curl-string default

curl -H "X-Vault-Request: true" -H "X-Vault-Token: $(bao print token)" "http://127.0.0.1:8200/v1/sys/policies/acl/default"
```
