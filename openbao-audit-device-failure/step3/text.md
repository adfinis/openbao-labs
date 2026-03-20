Let's see if we can learn something from the system logs.

* `journalctl -eu openbao`

Okay, it seems OpenBao isn't able to store audit logs anymore.

```
[ERROR] core: sanity check failed; unable to open "/var/log/openbao/audit.log" for writing: open /var/log/openbao/audit.log: permission denied
```

Let's check what might be the reason.

* `ls -al /var/log/openbao` 

```
total 28
drwxr-x---  2 root root    4096 Mar 20 09:42 .
drwxrwxr-x 17 root syslog  4096 Mar 20 09:42 ..
-rw-------  1 root root   16439 Mar 20 09:44 audit.log
``` 

Here we can san that `/var/log/openbao` is owned by root and only writeable by that user.

Let's check with which user is OpenBao running.

* `systemctl show -p User openbao.service` 

OpenBao is running with the `openbao` user. That's most likely our issue. Let's update the owner and restart the service.

* `chown -R openbao:openbao /var/log/openbao`
* `systemctl restart openbao`

Now OpenBao should be up and running again.
