> **Wait for the environment setup to complete, once you see "Ready to start!" message in the shell, you can get going.**

# Auto Unseal

In the previous lab we have seen how manual unsealing works with Shamir. While functionnal, this method involves having several person manually submitting their key shares each times an OpenBao node is restarted. This quite cumberstone in productive especially when running on Kubernetes where a pod might be rescheduled any time.

This why OpenBao provides an [auto unseal feature](https://openbao.org/docs/concepts/seal/#auto-unseal). This involve entrusting the keys to a KMS provider to automatically unseal OpenBao. OpenBao support several KMS providers. The auto unseal is [configured using the `seal` stanza](https://openbao.org/docs/configuration/seal/).

In This lab, we are going to configure OpenBao to use [a static key for auto unsealing](https://openbao.org/docs/configuration/seal/static/). This is a straightforward method that invlove providing the key as a file or an environment variable. This method should be carefully evaluated when used in productive environment for obvious security reasons but it's perfect to quickly demonstrate how auto unseal works.
