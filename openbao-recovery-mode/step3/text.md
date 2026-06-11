In recovery mode, OpenBao requires every request to be authenticated using a recovery token. This token can be generated similarly to a root token.

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
* `bao operator generate-root -nonce <nonce> -recovery-token <recovery-key>`

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

We can then use that token to send a request to `sys/raw`:
* `BAO_TOKEN=<recovery-token> bao list sys/raw`

```
Keys
----
auth/
core/
logical/
sys/
```
