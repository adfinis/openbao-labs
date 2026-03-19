Let's see if we can learn something from the system logs.

* `journalctl -eu openbao`

Okay, it seems OpenBao isn't able to store audit logs anymore.

Let's check what might be the reason.

* `ls -al /var/log/openbao` 

Here we can san that `/var/log/openbao` is owned by root and only writeable by that user.

Let's check with which user is OpenBao running.

* `systemctl status open` 

OpenBao is running with the `openbao` user. That's most likely our issue. Let's update the owner and restart the service.

* `chown -R openbao:openbao /var/log/openbao`
* `systemctl start openbao`

Now OpenBao should be up and running again.
