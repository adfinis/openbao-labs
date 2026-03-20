We just learned that if all enabled audit devices are failing, OpenBao will stop responding to requests. This is an important feature, as audit logs are critical in a production environment.

While it's not possible to prevent an audit device failure 100%, it's possible to enable multiple audit devices in anticipation of such scenarios. For example, you can enable an audit device that writes audit logs to a [file](https://openbao.org/docs/audit/file/) and an additional one that writes to a [remote server over HTTP](https://openbao.org/docs/audit/http/).

Note that since release [2.4.0 of OpenBao](https://github.com/openbao/openbao/releases/tag/v2.4.0), audit devices can only be enabled or disabled in a [declarative way](https://openbao.org/docs/configuration/audit/).

All audit device types are listed [in the documentation](https://openbao.org/docs/audit/).
