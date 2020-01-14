output "db password" {
  value = "${random_pet.replicated-pwd.id}"
}

output "pes_fqdn" {
  value = "${module.pes.pes_fqdn}"
}


output "db_endpoint" {
  value = "${module.pes.db_endpoint}"
}

output "s3_bucket" {
  value = "${module.pes.s3_bucketinfo}"
}