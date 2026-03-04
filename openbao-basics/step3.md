Now let's use the root token to authenticate to OpenBao.

There are several ways to pass a token to the Openbao CLI :

* `bao login` command: This command will prompt the user for the token. It also obfuscates the token, and it will not be leaked to shell history.
* `~/.vault-token` file: This is where the token is saved after using `bao login`. The CLI will also automatically look there for a valid token.
* `BAO_TOKEN` environment variable: Many tools support this method; however, keep in mind that the token might get leaked to the shell history. We don't recommend using this if alternatives are available.

Let's try using the `bao login` command with the root token from our dev server.

```
$ bao login
Token (will be hidden): 
Success! You are now authenticated. The token information displayed below is
already stored in the token helper. You do NOT need to run "bao login" again.
Future OpenBao requests will automatically use this token.

Key                  Value
---                  -----
token                s....
token_accessor       w...
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]
```

You will notice we get information about which policies are attached to our token. This directly informs us about what kind of permission we may have. The root policy cannot be read. But for any other policy we could check the rules with `bao policy read`, we can try that with the default policy.

```
bao policy read default
```

A single rule is formed by the [API path](https://openbao.org/api-docs/) and capabilities granted to that path. OpenBao policies are deny by default; thus, if nothing is specified, access will be denied. We will go over policies in another lab.

Now that we are logged in, we can try several things aside from reading policies.
For example : 
* We can check which auth methods are enabled: `bao auth list`
* We can check which secrets engine is enabled: `bao secrets list`
* We can list all the policies: `bao policy list`
* We can list all the nodes in the cluster: `bao operator raft list-peers`
* Feel free to also try out more stuff by [checking the documentation.](https://openbao.org/docs/commands/)

You can also explore the API with the CLI, using the verbs (read, list, write, delete). So, for example, to list the policies, instead of `bao policy list` you can do 

```
bao list sys/policies/acl
```

This works for any endpoint of the [API](https://openbao.org/api-docs/).
