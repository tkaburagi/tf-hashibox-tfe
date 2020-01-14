# Lab 2: Certificate Generation

Duration: 10 minutes

There are two places where a customer may need to input certificate chain information during a PTFE Installation - for hostname resolution and for private CA trust for other service integration like VCS or SSO. For this purpose, we'll be logging into our new instance and creating an NGINX cert for PTFE to use.

### Lab Overview

- Task 1: SSH into your PTFE instance
- Task 2: Install and configure Certbot

## Task 1: SSH into your instance

### Step 2.1.1

In the previous lab, you should have received an IP address corresponding to the Elastic IP of our deployment. SSH into that with the default username for the instance.

```shell
$ ssh ubuntu@<ip-address>
```

This is the Primary PTFE instance for our deployment. Feel free to explore the instance and note any additional installation scripts or config files you see - we'll go into more depth on those later.

## Task 2: Install and configure Certbot

### Step 2.2.1

You can add the Certbot package repo to your list of repositories with the following commands:

```shell
$ sudo apt-get update
$ sudo apt-get install software-properties-common
$ sudo add-apt-repository universe
$ sudo add-apt-repository ppa:certbot/certbot
$ sudo apt-get update
$ sudo apt-get install certbot python-certbot-nginx
```

### Step 2.2.2

Certbot has an Nginx plugin, which is supported on many platforms, and automates certificate installation.

```shell
$ sudo certbot --nginx
```

Follow the prompts and enter the necessary information with your EIP being the hostname (`{namespace}.hashicorp.fun`).

Navigate to the cert creation point and examine the certs you just created.

`$ sudo su -`
`$ cd etc/letsencrypt/live/{namespace}.hashicorp.fun`