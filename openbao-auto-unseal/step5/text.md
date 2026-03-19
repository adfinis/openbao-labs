We can now initialize OpenBao.

`kubectl exec openbao-0 -ti -- bao operator init -recovery-shares=1 -recovery-threshold=1`

You will notice we used a different set of flags this time `-recovery-shares=1 -recovery-threshold=1`. This is because with auto-unseal, OpenBao will generate recovery keys instead of unseal keys. 
It's important to note that recovery keys cannot be used to unseal OpenBao. The only way to unseal OpenBao now is to use the static key. If the static key is lost, there is no way to recover the OpenBao cluster, even from backups.

``` 
Recovery Key 1: ...

Initial Root Token: ...
```

If all went well, OpenBao should be directly unsealed. We can check that with the OpenBao CLI (`BAO_ADDR` has already been set for you).

* Use `bao status`
* Use `bao login` with the initial root token
* You can also reschedule the pod and see that OpenBao unseals itself again. With `kubectl logs openbao-0` you can see the auto-unsealing process happening.
