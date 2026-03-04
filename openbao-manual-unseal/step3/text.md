We can submit the key using the `bao operator unseal` command.

`kubectl exec openbao-0 -ti -- bao operator unseal`

After submitting the key, you should see that `Sealed` is now `false`. Meaning OpenBao is now unsealed.

```
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
....
``` 

Once the unsealing is completed, you can use the `bao` CLI to interact with Vault (the `BAO_ADDR` variable has already been set for you).

* Try `bao status`
* Try `bao login` using the initial root token
* You can try rescheduling the pod (`kubectl rollout restart sts openbao). You will notice you need to unseal OpenBao again. There is an auto-unseal feature, which we explore in another lab.
