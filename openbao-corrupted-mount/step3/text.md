Since we cannot interact with OpenBao, our first step should be to run the server in recovery mode.

For this we want to override the systemd unit and add the `-recovery` flag:
* `systemctl edit openbao`

> Side note: the empty `ExecStart=` is needed because it's parsed by systemd as a list. See [here](https://www.freedesktop.org/software/systemd/man/latest/systemd.unit.html#Examples): "...if one wants to remove entries from a setting that is parsed as a list (and is not a dependency), such as AssertPathExists= (or e.g. ExecStart= in service units), one needs to first clear the list before re-adding all entries except the one that is to be removed".

```
[Service]
ExecStart=
ExecStart=/usr/local/bin/bao server -config=/etc/openbao/openbao.hcl -recovery
```

Then restart the service:
* `systemctl restart openbao`

OpenBao should now start in recovery mode:
* `journalctl -eu openbao`

```
==> OpenBao server configuration:
    Seal Type: static
    Static KMS Key ID: 20260302-1
    Cluster Address: https://127.0.0.1:30201
    Go Version: go1.25.10
    Log Level:
    Recovery Mode: true
    Storage: raft
    Version: OpenBao v2.5.4, built 2026-05-20T16:08:53Z
    Version Sha: 4f6d47246a053375271a5fd8af85c3b75695aa46
```

## Generate recovery token

Now we need to generate a recovery token.

Start by generating an OTP:
* `bao operator generate-root -generate-otp -recovery-token`

Initiate the recovery token generation using the OTP:
* `bao operator generate-root -init -otp=<otp> -recovery-token`

This gives us a `nonce` that we will need to submit in the following steps.
```bash
Nonce         9e2de75b-e1aa-b358-eaaf-c97dbd02fc31
Started       true
Progress      0/1
Complete      false
OTP Length    28
```

Submit the recovery key share we retrieved earlier:
* `bao operator generate-root -nonce <nonce> -recovery-token $(cat /root/assets/recovery-key.txt)`

This will give an encoded recovery token:
```bash
Nonce            9e2de75b-e1aa-b358-eaaf-c97dbd02fc31
Started          true
Progress         1/1
Complete         true
Encoded Token    JxIFaxFAIncVI0QfdC8tEXYBEAgeADwPfDclFA
```

We can now decode the recovery token:
* `bao operator generate-root -decode=<encoded-token> -otp=<otp> -recovery-token`

We can then use that token to send requests against `sys/raw`:
```bash
export BAO_TOKEN=<recovery-token>
bao list sys/raw
```
