We just learned that if all enabled audit device are failing, OpenBao will stop respond to request. This an important feature as audit logs are critical in a production environment. 

While it's not possible to 100% prevent an audit device failure, it's possible to enable mutltiple audit device in anticipation of such scenarios. For example, you can enable an audit device that writes audit log to a [file](https://openbao.org/docs/audit/file/) and an additionnal one that writes to a [remote server over HTTP](https://openbao.org/docs/audit/http/).

Note that since release [2.4.0 of OpenBao](https://github.com/openbao/openbao/releases/tag/v2.4.0), audit devices can only be enabled or disabled in a [declarative way](https://openbao.org/docs/configuration/audit/).

All audit device type are listed [in the documentation](https://openbao.org/docs/audit/).
