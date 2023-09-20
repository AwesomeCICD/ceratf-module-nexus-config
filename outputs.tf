output "admin_password" {
  value = "Nexus is using default admin password admin123 you should change that."

}
output "deployer_password" {
  value     = random_password.deployer_password.result
  sensitive = true
}

output "deployer_username" {
  value     = nexus_security_user.cera_deployer.userid
  sensitive = true
}

