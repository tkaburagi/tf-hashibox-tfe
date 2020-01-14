terraform {
  required_version = ">= 0.11.0"
}

provider "aws" {
  region = "${var.aws_region}"
}

data "aws_route53_zone" "hashidemos" {
  name = "hashicorp.fun."
}

#------------------------------------------------------------------------------
# instance user data
#------------------------------------------------------------------------------

resource "random_pet" "replicated-pwd" {
  length = 2
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.tpl")}"

  vars {
    hostname       = "${var.namespace}.hashicorp.fun"
    replicated_pwd = "${random_pet.replicated-pwd.id}"
  }
}

#------------------------------------------------------------------------------
# network
#------------------------------------------------------------------------------

module "network" {
  source    = "network/"
  namespace = "${var.namespace}"
}

#------------------------------------------------------------------------------
# production external-services ptfe
#------------------------------------------------------------------------------

module "pes" {
  source                 = "pes/"
  namespace              = "${var.namespace}"
  aws_instance_ami       = "${lookup(var.images, var.aws_region)}"
  aws_instance_type      = "${var.aws_instance_type}"
  subnet_ids             = "${module.network.subnet_ids}"
  vpc_security_group_ids = "${module.network.security_group_id}"
  user_data              = "${data.template_file.user_data.rendered}"
  ssh_key_name           = "${var.ssh_key_name}"
  public_key             = "${var.public_key}"
  hashidemos_zone_id     = "${data.aws_route53_zone.hashidemos.zone_id}"
  database_pwd           = "${random_pet.replicated-pwd.id}"
  db_subnet_group_name   = "${module.network.db_subnet_group_id}"
  owner                  = "${var.owner}"
  ttl                    = "${var.ttl}"
}
