Now that the auth method is configured, we should also create a secret to fetch in our KV secrets engine :

* `bao kv put -mount=kv openbao-eso-lab secret=eso-lab-2026`

Next, we need to allow the service account to read that secret. For that, we will create a policy and attach it to an identity.

A policy is already prepared and stored at `/root/assets/read-kv.hcl`. Let's see the content :

```hcl
path "kv/*" {
  capabilities = ["read"]
}
```

Essentially, this policy grants `read` capabilites to anything under the `kv/` path. Let's create the policy :

* `bao policy write read-kv /root/assets/read-kv.hcl`

Now, we can create an entity for our service account and attach the policy to that entity :

* `bao write /identity/entity name=lab-my-app policies=read-kv`

The next step is to create an entity alias. For this we need the entity ID, the mount accessor of the auth method, and the alias name. Remember, in the previous step we added `alias_name_source=serviceaccount_name` to the role configuration. This is relevant here as it tells us how to name our alias so that it can [bind](https://openbao.org/docs/concepts/identity/#mount-bound-aliases) to the actual client. With Kubernetes auth, the default is `alias_name_source=serviceaccount_uid` while more secure is impractical when pre-provisioning the entity.

Get the auth method accessor :
* `bao read /sys/auth/kubernetes`

* Create the entity alias:

```bash
bao write /identity/entity-alias \
name=lab/my-app \
canonical_id=<entity_id> \
mount_accessor=<auth_method_accessor>
```

We could have simply attached the policy directly to the role, but this is a nicer setup. Actively using entities and aliases allows you to leverage [entity metadata to template policies](https://openbao.org/docs/concepts/policies/#parameters).
