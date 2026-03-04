> **Wait for the environment setup to complete, once you see "Ready to start!" message in the shell, you can get going.**

# Auto Unseal

In the previous lab, we saw how manual unsealing works with Shamir. While functional, this method involves having several people manually submit their key shares each time an OpenBao node is restarted. This is quite cumbersome in a productive environment, especially when running on Kubernetes, where a pod might be rescheduled any time.

This is why OpenBao provides an [auto-unseal feature](https://openbao.org/docs/concepts/seal/#auto-unseal). Auto-unseal involves entrusting the keys to a KMS provider to automatically unseal OpenBao. OpenBao supports several KMS providers. The auto-unseal is [configured using the `seal` stanza](https://openbao.org/docs/configuration/seal/).

In this lab, we are going to configure OpenBao to use [a static key for auto-unsealing](https://openbao.org/docs/configuration/seal/static/). This is a straightforward method that involves providing the key as a file or an environment variable. This method should be carefully evaluated when used in a productive environment for obvious security reasons, but it's perfect to quickly demonstrate how auto-unseal works.
