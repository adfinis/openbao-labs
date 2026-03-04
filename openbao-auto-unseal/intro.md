# Welcome !

![OpenBao logo](https://raw.githubusercontent.com/openbao/artwork/main/color/openbao-color.svg)

In this scenario, we are going to configure OpenBao to use auto unseal.

When an OpenBao server starts, it is in a sealed state. In this state, OpenBao is unable to decrypt its storage. Before being able to interact with the OpenBao server, it needs to be unsealed so that the storage can be decrypted.

More information on the [seal/unseal mechanism and concept in the docs](https://openbao.org/docs/concepts/seal/#auto-unseal).

If you encounter any problem with the lab content, please create [an issue on our GitHub repository](https://github.com/adfinis/openbao-labs).
