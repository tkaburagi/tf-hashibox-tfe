# Lab 1: Infrastructure and Prerequisites

Duration: 20 minutes

This lab will establish the underlying infrastructure for our PTFE setup. For more information on these requirements, please see the [Preflight Requirements](https://www.terraform.io/docs/enterprise/private/preflight-installer.html) and the [AWS Reference Architecture](https://www.terraform.io/docs/enterprise/private/aws-setup-guide.html).

### Course Prerequisites:
- A Replicated Installer License - If you do not have a replicated license, please contact [the helpdesk](helpdesk@hashicorp.com).
- Ability to SSH into a workstation
- Comfort with command line & understanding of Terraform

- Task 1: Connect to the Student Workstation
- Task 2: Verify Terraform installation
- Task 3: Generate your first Terraform Configuration
- Task 4: Use the Terraform CLI to Get Help
- Task 5: Apply and Update your Configuration

## Task 1: Connect to the Student Workstation

### Step 1.1.1

SSH into your workstation using the provided credentials.

```shell
$ ssh <student_id>@<workstation_IP_address>
password: <student_password>
```

When you are prompted, enter "yes" to continue connecting.

On Windows, use an SSH client such as PuTTY.  On a Linux or Mac, use the Terminal to SSH into your workstation.

When you are prompted, enter the username and password provided by your instructor.

## Task 2: Verify Terraform installation

### Step 1.2.1

Run the following command to check the Terraform version:

```shell
$ terraform --version

Terraform v0.11.7
```

## Task 3: Inspect your PTFE Infra Configuration

Navigate to `/workstation/ptfe`.

Examine the `main.tf` file. Examine the deployment structure in the `/network` and `/pes` folders.

Once you've familiarized yourself with the deployment structure and the resources we'll be creating, edit the `terraform.tfvars.example` file with your own variables.

```shell
vim terraform.tfvars.example
```

The public key we'll use is in `~/.ssh/id_rsa.pub`. Copy the contents of this file into the `public_key` variable here.

Below is an example of the variable file. Leave the `aws_instance_type` & `ttl` values

```hcl
aws_region = "us-east-2"
namespace = "res-ptfe"
aws_instance_type = "m5.large"
public_key = "ssh-rsa AAAA... rachel@hashicorp.com"
owner = "rachel"
ttl = "-1"
```

Save the file as `terraform.tfvars`

## Task 4: Init & Apply

### Step 1.4.1

Once your variables are set, initialize Terraform in the `aws` directory.

```shell
$ cd .../aws/
$ terraform init

Initializing provider plugins...
...

Terraform has been successfully initialized!
```

### Step 1.4.2

Apply your configuration and note the output you've received.

```shell
terraform apply
```

If you've received any errors, go back to your variables and ensure you've given the correct information.