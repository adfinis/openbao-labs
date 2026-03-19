listener "tcp" {
  tls_disable = 1
  address = "[::]:30200"
  cluster_address = "[::]:30201"
}
storage "raft" {
  path = "/opt/openbao/data"
}
seal "static" {
  current_key_id = "20260302-1"
  current_key = "file:///etc/openbao/unseal/unseal-20260302-1.key"
}
initialize "init-config" {
  request "enable-audit" {
    operation = "update"
    path = "sys/audit/file"
    data = {
      type = "file"
      options = {
        file_path = "/var/log/openbao/audit.log"
      }
    }
  }
  request "admin-policy" {
    operation = "create"
    path = "sys/policies/acl/admin"
    data = {
      "policy" = "path \"*\" {\n    capabilities = [\"create\", \"read\", \"patch\", \"update\", \"delete\", \"list\", \"sudo\"]\n}\n"
    }
  }
  request "enable-userpass" {
    operation = "create"
    path = "sys/auth/userpass"
    data = {
      type = "userpass"
    }
  }
  request "create-admin" {
    operation = "create"
    path = "auth/userpass/users/admin"
    data = {
      password = "admin123"
      token_policies = "admin"
    }
  }
}
