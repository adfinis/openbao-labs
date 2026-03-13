Before deploying and configuring External Secrets Operator, we need to configure an appropriate authentication method that it can use.

ESO supports several authentication methods from OpenBao. For Kubernetes workloads, [JWT](https://openbao.org/docs/auth/jwt/) or [Kubernetes auth methods](https://openbao.org/docs/auth/kubernetes/) are recommended.

For this lab, we will use the Kubernetes auth method.

Let's start by enabling the authentication method.

* `bao auth enable kubernetes`

Then we need to configure the authentication method and set the `kubernetes_host` parameters to the control plane address.

* `kubectl cluster-info` to get the control plane address
* `bao write auth/kubernetes/config kubernetes_host=https://<control-plane-address>:<port>`

In this lab we are running OpenBao and ESO on the same cluster, so the config above is sufficient. In a productive environment, we would likely run OpenBao on a cluster that is separated from the workload fetching the secret. In that case we would need to set some additionnal configuration parameter depending on the environment. [The project documentation](https://openbao.org/docs/auth/kubernetes/#kubernetes-121) provides an overview of those configuration options depending on a few scenarios.

We still need to configure a role in our authentication method. Here we need to reference the service accounts allowed to use the role. Here we allow the service account `my-app` from the namespace `lab`. We will see why we use `alias_name_source=serviceaccount_name` in the next step.

```bash
bao write auth/kubernetes/role/lab \
    bound_service_account_names=my-app \
    bound_service_account_namespaces=lab \
    alias_name_source=serviceaccount_name \
    ttl=1h
```
