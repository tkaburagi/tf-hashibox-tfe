# Lab 4: Configuring Bitbucket Server Access

## Prerequisites

- Bitbucket Server account
  - Email helpdesk@hashicorp.com for access
- Ability to create SSH keys on your local machine

### Lab Overview

- Task 1: On PTFE, Add a VCS Provider
- Task 2: On Bitbucket Server, Create a New Application Link
- Task 3: On Workstation: Create an SSH Key for TFE
- Task 4: On Bitbucket Server, Switch Users and Add an SSH Key

## Task 1: On PTFE, Add a VCS Provider

### Step 4.1.1

Open TFE in your browser and navigate to the "VCS Provider" settings for your organization. Click the "Add VCS Provider" button.

    If you just created your organization, you might already be on this page. Otherwise:

    1. Click the upper-left organization menu, making sure it currently shows your organization.
    2. Click the "Settings" link at the top of the page.
    3. On the next page, click "VCS Provider" in the left sidebar.
    4. Click the "Add VCS Provider" button.

### Step 4.1.2

The next page has a drop-down and several text fields. Select "Bitbucket Server" from the drop-down. Several text fields will vanish, leaving only two. Enter the URL of your Bitbucket Server instance in both fields. The API URL should be the same as the main URL.

### Step 4.1.3

Click "Create VCS Provider." This will take you back to the VCS Provider page, which now includes your new Bitbucket Server client.

### Step 4.1.4

Leave this page open in a browser tab. In the next step, you will copy and paste the unique **Consumer Key** and **Public Key.**

## Task 2: On Bitbucket Server, Create a New Application Link

### Step 4.2.1

While logged in as an admin user, go to Bitbucket Server's "Application Links" administration page. You can use the sidebar navigation in the admin pages, or go directly to `https://<BITBUCKET INSTANCE HOSTNAME>/plugins/servlet/applinks/listApplicationLinks`.

    This page has a text field for creating a new application link, followed by a list of existing application links.

### Step 4.2.2

Enter TFE's URL in the text field (`https://app.terraform.io`, or the hostname of your private TFE instance) and click the "Create new link" button.

    ~> **Note:** If you're connecting multiple TFE organizations to the same Bitbucket Server instance, you can only use TFE's main URL once. For subsequent organizations, you can enter the organization URL instead. Organization URLs look like `https://app.terraform.io/app/<ORG NAME>` or `https://<TFE HOSTNAME>/app/<ORG NAME>` — it's the page TFE's "Workspaces" button takes you to.

### Step 4.2.3 In the "Configure application URL" dialog, confirm that you wish to use the URL exactly as you entered it. If you used TFE's main URL, click "Continue;" if you used an organization URL, click the "Use this URL" checkbox and then click "Continue."

### Step 4.2.4

In the "Link applications" dialog, fill out the form fields as follows:

    Field                           | Value
    --------------------------------|------------------------------------
    Application Name (text)         | Terraform Enterprise (`<ORG NAME>`)
    Application Type (drop-down)    | Generic Application
    Create incoming link (checkbox) | ✔️ (enabled)

    Leave all the other fields blank, and click "Continue."


### Step 4.2.5

This takes you to another dialog, also titled "Link applications," with three text fields. In the "Consumer Key" and "Public Key" fields, copy and paste the values from step 2. In the "Consumer Name" field, enter "Terraform Enterprise (`<ORG NAME>`)." Click "Continue."

## Task 3: On Workstation: Create an SSH Key for TFE

On a secure workstation, create an SSH keypair that TFE can use to connect to Bitbucket Server. The exact command depends on your OS, but is usually something like `ssh-keygen -t rsa -f "/Users/<NAME>/.ssh/service_tfe" -C "service_terraform_enterprise"`. This creates a `service_tfe` file with the private key, and a `service_tfe.pub` file with the public key.

This SSH key **must have an empty passphrase.** TFE cannot use SSH keys that require a passphrase.

### Important Notes

- Do not use your personal SSH key to connect TFE and Bitbucket Server; generate a new one or use an existing key reserved for service access.
- In the following steps, you must provide TFE with the private key. Although TFE does not display the text of the key to users after it is entered, it retains it and will use it for authenticating to Bitbucket Server.
- **Protect this private key carefully.** It can push code to the repositories you use to manage your infrastructure. Take note of your organization's policies for protecting important credentials and be sure to follow them.

## Task 4: On Bitbucket Server, Switch Users and Add an SSH Key

### Step 4.4.1

If you are still logged in to Bitbucket Server as an administrator, log out now.

### Step 4.4.2

Log in as whichever account you want TFE to act as. For most organizations this should be a dedicated service user, but a personal account will also work.

    ~> **Important:** The account you use for connecting TFE **must have admin access** to any shared repositories of Terraform configurations, since creating webhooks requires admin permissions.

### Step 4.4.3

Go to the "SSH keys" page. You can click the profile icon in the upper right corner, choose "Manage account," then click "SSH keys" in the sidebar navigation, or you can go directly to `https://<BITBUCKET INSTANCE HOSTNAME>/plugins/servlet/ssh/account/keys`.

### Step 4.4.4

Click the "Add key" button. Paste the text of the **SSH public key** you created in step 4 (from the `.pub` file) into the text field, then click the "Add key" button to confirm.

## Task 5: On TFE, Request Access and Add an SSH Private Key

### Step 4.5.1

Go back to your TFE browser tab and click the "Connect organization `<NAME>`" button on the VCS Provider page.

    This takes you to a page on your Bitbucket Server instance, asking if you want to authorize TFE. Double-check that you're logged in as the user account TFE will be using, and not as a Bitbucket administrator.


### Step 4.5.2

Click the "Allow" button. This returns you to TFE's VCS Provider page, where the Bitbucket Server client's information has been updated.

    If this results in a 500 error, it usually means TFE was unable to reach your Bitbucket Server instance.

### Step 4.5.3

Click the "Add a private SSH key" link. A large text field will appear. Paste the text of the **SSH private key** you created in step 4, and click the "Add SSH Key" button.

At this point, Bitbucket Server access for TFE is fully configured, and you can create Terraform workspaces based on your organization's shared repositories.