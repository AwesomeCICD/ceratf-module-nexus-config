
resource "random_password" "deployer_password" {
  length  = 24
  special = false
}

resource "vault_kv_secret_v2" "cera_deployer" {
  mount = var.vault_mount_path
  name  = "nexus/boa-deployer"
  data_json = jsonencode(
    {
      username = nexus_security_user.cera_deployer.userid,
      password = random_password.deployer_password.result
    }
  )
}

resource "nexus_security_anonymous" "system" {
  enabled = true
}

resource "nexus_repository_docker_hosted" "cera_hosted" {
  name   = "cera-hosted"
  online = true

  docker {
    force_basic_auth = false
    v1_enabled       = false
    http_port        = 8443
  }

  storage {
    blob_store_name                = "default"
    strict_content_type_validation = true
    write_policy                   = "ALLOW"
  }

  # cleanup {
  #   policy_names = []
  # }

}

resource "nexus_repository_helm_hosted" "cera_helm" {
  name   = "cera-helm"
  online = true

  storage {
    blob_store_name                = "default"
    strict_content_type_validation = false
    write_policy                   = "ALLOW"
  }
}

resource "nexus_security_role" "cera_deploy" {
  description = "Docker deployment role"
  name        = "CERA Deployer"
  privileges = [
    "nx-repository-admin-docker-cera-hosted-*",
    "nx-repository-admin-helm-cera-helm-*",
    "nx-repository-view-docker-*-*"
  ]
  roleid     = "cera-deployer"
  depends_on = [nexus_repository_docker_hosted.cera_hosted, nexus_repository_helm_hosted.cera_helm]
}

resource "nexus_security_user" "cera_deployer" {
  userid    = "cera-deployer"
  firstname = "CERA"
  lastname  = "Deployer"
  email     = "eddie@circleci.com"
  password  = random_password.deployer_password.result
  roles     = [nexus_security_role.cera_deploy.roleid, "nx-anonymous"]
  status    = "active"

  depends_on = [nexus_security_role.cera_deploy]
}


resource "nexus_security_realms" "example" {
  active = [
    "NexusAuthenticatingRealm",
    "DockerToken"
  ]
}

resource "null_resource" "always_run" {
  triggers = {
    timestamp = "${timestamp()}"
  }
}
resource "nexus_script" "cleanup_policy_create" {
  name       = "create-docker-cleanup-policy"
  type       = "groovy"
  content    = file("${path.module}/cleanup-policy.groovy")
  depends_on = [nexus_repository_docker_hosted.cera_hosted]
  lifecycle {
    replace_triggered_by = [
      null_resource.always_run.timestamp
    ]
  }
}
