output "pes_fqdn" {
  value = "${aws_route53_record.pes.fqdn}"
}

output "db_endpoint" {
  value = "${aws_db_instance.pes.endpoint}"
}

output "s3_bucketinfo" {
  value = "${aws_s3_bucket.pes.bucket_domain_name}"
}