Let's start by generating the static key.

`openssl rand -out /root/assets/unseal-20260302-1.key 32`

Now let's store this key as a Kubernetes secret that will mount later into the OpenBao pod.

`kubectl create secret generic openbao-unseal-key --from-file=unseal-20260302-1.key=/root/assets/unseal-20260302-1.key`
