# ceratf-module-helm-nexus-config
<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

No requirements.
## Usage
Basic usage of this module is as follows:
```hcl
module "nexus-config" {
	source  = "git@github.com:AwesomeCICD/ceratf-module-helm-nexus-config?ref=X.X.X"

	depends_on = [module.vault_config]
}
```
## Resources

| Name | Type |
|------|------|
| [nexus_repository_docker_hosted.cera_hosted](https://registry.terraform.io/providers/hashicorp/nexus/latest/docs/resources/repository_docker_hosted) | resource |
| [nexus_repository_helm_hosted.cera_helm](https://registry.terraform.io/providers/hashicorp/nexus/latest/docs/resources/repository_helm_hosted) | resource |
| [nexus_security_anonymous.system](https://registry.terraform.io/providers/hashicorp/nexus/latest/docs/resources/security_anonymous) | resource |
| [nexus_security_realms.example](https://registry.terraform.io/providers/hashicorp/nexus/latest/docs/resources/security_realms) | resource |
| [nexus_security_role.cera_deploy](https://registry.terraform.io/providers/hashicorp/nexus/latest/docs/resources/security_role) | resource |
| [nexus_security_user.cera_deployer](https://registry.terraform.io/providers/hashicorp/nexus/latest/docs/resources/security_user) | resource |
| [random_password.deployer_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [vault_kv_secret_v2.cera_deployer](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vault_mount_path"></a> [vault\_mount\_path](#input\_vault\_mount\_path) | n/a | `string` | `"secret"` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_password"></a> [admin\_password](#output\_admin\_password) | n/a |
| <a name="output_deployer_password"></a> [deployer\_password](#output\_deployer\_password) | n/a |
| <a name="output_deployer_username"></a> [deployer\_username](#output\_deployer\_username) | n/a |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->