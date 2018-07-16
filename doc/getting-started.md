---
layout: index
---

# Getting started
<!-- TOC depthFrom:1 depthTo:4 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Getting started](#getting-started)
	- [Introduction](#introduction)
	- [Requirements](#requirements)
		- [Git](#git)
		- [Vagrant](#vagrant)
		- [Virtualbox](#virtualbox)
		- [Atlassian tools licenses](#atlassian-tools-licenses)
		- [Minishift](#minishift)
		- [Bash](#bash)
		- [Ansible](#ansible)
	- [Setup your local environment](#setup-your-local-environment)
		- [Prepare infrastructure](#prepare-infrastructure)
		- [Install Atlassian Tools and Rundeck](#install-atlassian-tools-and-rundeck)
			- [Crowd Setup](#crowd-setup)
			- [Bitbucket Setup](#bitbucket-setup)
			- [Jira Setup](#jira-setup)
			- [Confluence Setup](#confluence-setup)
			- [Rundeck Setup](#rundeck-setup)
		- [Configure Minishift](#configure-minishift)
			- [Minishift startup](#minishift-startup)
			- [Install the OC CLI](#install-the-oc-cli)
			- [Login with the CLI](#login-with-the-cli)
			- [Setup the base template project](#setup-the-base-template-project)
			- [Adjust user rights for the developer user](#adjust-user-rights-for-the-developer-user)
			- [Create service account for deployment](#create-service-account-for-deployment)
			- [Install Minishift certificate on Atlassian server](#install-minishift-certificate-on-atlassian-server)
		- [Setup and Configure Nexus3](#setup-and-configure-nexus3)
			- [Prepare in Minishift](#prepare-in-minishift)
			- [Add persistent claim](#add-persistent-claim)
			- [Configure Repository Manager](#configure-repository-manager)
		- [Import base templates](#import-base-templates)
		- [Configure CD user](#configure-cd-user)
		- [Configure Rundeck](#configure-rundeck)
			- [Create Quickstarters project](#create-quickstarters-project)
			- [Openshift API token](#openshift-api-token)
			- [CD user private key](#cd-user-private-key)
			- [Configure SCM plugins](#configure-scm-plugins)
		- [Configure provisioning application](#configure-provisioning-application)
	- [Try out the OpenDevStack](#try-out-the-opendevstack)

<!-- /TOC -->

## Introduction
Welcome to the OpenDevStack. The OpenDevStack is a framework to help in setting up a project infrastructure and continuous delivery processes on OpenShift and Atlassian toolstack with one click. This guide shall help you to setup the OpenDevStack, so you can work with it and test it in a local environment setup. The steps for the setup can also be adapted for running the OpenDevstack with an existing OpenShift installation or to connect it with your Atlassian tools, if you use [Atlassian Crowd](https://www.atlassian.com/software/crowd "Atlassian Crowd") as SSO provider.

**Important: The credentials provided in the guide are only meant to be used within the local test installation. For use in production you will have to customize paths, URLs and credentials!**

## Requirements
The following requirements have to be met to setup a local environment
### Git
We use Git as code repository, so you have to be familiar to work with [Git](https://git-scm.com/ "Git").
### Vagrant
The OpenDevStack uses Vagrant to provide a sample infrastructure for the Atlassian tools, Rundeck and a so called Ansible controller, a VM, where you can run Ansible scripts against the Atlassian VM. It is recommended to use the latest Vagrant version available from the [HashiCorp Vagrant page](https://www.vagrantup.com "Vagrant").

### Virtualbox
Vagrant uses Virtualbox for running the provisioned VMs. Therefore you must have [Virtualbox](https://www.virtualbox.org/ "Virtualbox") installed.
### Atlassian tools licenses
To use the Atlassian tools you need a license to run them. For testing and evaluation Atlassian provides evalutation licenses, which you can get on the [My Atlassian license page](https://my.atlassian.com/products/index "My Atlassian").
Here you have to keep in mind, that you have to register, if you don't have an Atlassian account. The registration is for free.
You need licenses for the following products:

- Bitbucket
- Jira
- Confluence
- Crowd

The evaluation licenses are valid for 30 days from the date of purchase. If you need a server id, this will be provided by the tools within the installation, so you are able to inlcude the licenses within the
installation wizards of the tools, after the base setup provided by the Ansible scripts.

### Minishift

The provided provision application and Rundeck jobs work with links, which are designed to connect to a installed and configured [Minishift](https://docs.openshift.org/latest/minishift/index.html "Minishift") instance. Minishift is a tool provided by Redhat to run OpenShift locally by providing a single-node OpenShift cluster inside a VM.
Informations, how to setup Minishift can be found at the [Minishift Getting Started guide](https://docs.openshift.org/latest/minishift/getting-started/index.html "Getting Started with Minishift").
For the OpenDevStack it is important, that you run Minishift with OpenShift v3.6.1 because the templates have been designed for OpenShift v3.6 and the current OpenShift version is not backward compatible.

### Bash

You must have the possibility to run bash scripts to import the provided OpenShift templates. On Linux systems you can use these scripts out-of-the box, on Windows systems you will have to install either a bash port for Windows like [Cygwin](https://www.cygwin.com/ "Cygwin") or [win-bash](http://win-bash.sourceforge.net/ "win-bash") or you can use the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10 "Windows Subsystem for Linux"), if you run Windows 10.

### Ansible

The OpenDevStack uses [Ansible](https://www.ansible.com/ "Ansible") to install and configure the necessary software for the enabling stack, so it's recommended to get familiar with its core concepts and usage. Also credentials are stored within an Ansible vault, so even if you commit them in a public repository they are not available unless you know the vault password.

## Setup your local environment

### Prepare infrastructure

First you have to clone the [infrastructure repository](http://www.github.com/opendevstack/infrastructure).
If you have cloned the repository in your IDE or via a GUI you have to open a Shell and navigate to the folder, where you have cloned the repository to.
There you will find the Vagrant file. You can start the infrastructure provisioning and setup by using
```
vagrant up
```
After Vagrant has provisioned the VMs you are able to connect to them. There are two VMs, `atlcon` and `atlassian1`.
First connect to the Ansible controller `atlcon` from the directory you ran the Vagrantfile from via
```
vagrant ssh atlcon
```
After the connect change the directory to `/vagrant/ansible`.
Here you have to execute the following command:
```
ansible-playbook -i inventories/dev dev.yml --ask-vault-pass
```
This playbook prepares the ansible controller and basic installations on the `atlassian1` VM like a local database and the necessary schemas with their respective user.
The password for the vault located under `ansible/inventories/dev/group_vars/all/vault.yml` is `opendevstack`.
Depending on your network or proxy configuration it might happen that some online resources are not reachable. Please try to execute the playbook again in such a case.

**All ansible playbook commands in this guide have to be executed from the Ansible controller like described before!**

### Install Atlassian Tools and Rundeck

The following steps explain the Atlassian tools and the Rundeck installation.

#### Crowd Setup

##### Setup Application
Downloading and Configuring as service
```
ansible-playbook -v -i inventories/dev playbooks/crowd.yml --ask-vault
```
##### Run Configuration Wizard

Access http://192.168.56.31:8095/crowd/console

Be patient. First time accessing this page will take some time.

###### Step 1: License key
Here you can see the server id you need for the license you can get from the [My Atlassian page](https://my.atlassian.com/products/index "My Atlassian"). Use the link to get an evaluation license (Crowd Server) or enter a valid license key into the textbox.
###### Step 2: Crowd installation
Here choose the **New installation** option.
###### Step 3: Database Configuration
The next step is the database configuration.
Choose the **JDBC Connection** option and configure the database with the following settings

| Option            | Value                                                                                                                |
| ----------------- | -------------------------------------------------------------------------------------------------------------------- |
| Database          | PostgreSQL                                                                                                           |
| Driver class name | org.postgresql.Driver                                                                                                |
| JDBC URL          | jdbc:postgresql://localhost:5432/atlassian?currentSchema=crowd&amp;reWriteBatchedInserts=true&amp;prepareThreshold=0 |
| Username          | crowd                                                                                                                |
| Password          | crowd                                                                                                                |
| Hibernate dialect | org.hibernate.dialect.PostgreSQLDialect                                                                              |



###### Step 4: Options
Choose a deployment title, e.g. *OpenDevStack* and set the **Base URL** to `http://192.168.56.31:8095/crowd`

###### Step 5: Mail configuration
For the local test environment a mail server is not necessary, so you can skip this step by choosing **Later**

###### Step 6: Internal directory
Enter the name for the internal crowd directory, e.g. *OpenDevStack*

###### Step 7: Default administrator
Enter the data for the default administrator, so you are able to login to crowd.

###### Step 8: Integrated applications
Enable both integrated applications.

###### Step 9: Log in to Crowd console
Now you can verify the installation and log in with the credentials defined in the previous step.

##### Configure Crowd
You will have to configure crowd to enable the Atlassian tools and Rundeck to login with crowd credentials.

###### Add OpenDevStack groups
You will have to add the following groups to crowd's internal directory

| Group                       | Description                                         |
| --------------------------- | --------------------------------------------------- |
| opendevstack-users          | Group for normal users without adminstration rights |
| opendevstack-administrators | Group for administration users                      |

###### Add Atlassian groups
You also have to add the groups from the atlassian tools, even if you don't use them.

| Group                     | Description                    |
| ------------------------- | ------------------------------ |
| bitbucket-administrators  | Bitbucket administrator group  |
| bitbucket-users           | Bitbucket user group           |
| jira-administrators       | Jira administrator group       |
| jira-developers           | Jira developers group          |
| jira-users                | Jira user group                |
| confluence-administrators | Confluence administrator group |
| confluence-users          | Confluence user group          |

To do so, access the crowd console at http://192.168.56.31:8095/crowd/console/
Choose the **Groups** menu point and click **Add group**
Enter the group name like shown above and link it to the created internal directory.

###### Add groups to user
Now you have to add all groups to the administrator.
Go to the **Users** section in Crowd, choose your administration user and open the **Groups** tab.
Click **Add groups**, search for all by leaving the Search fields empty and add all groups.

###### Add applications to crowd
You will have to add the applications you want to access with your Crowd credentials in the Crowd console.
Access the Crowd console at http://192.168.56.31:8095/crowd/console/
Choose the **Applications** menu point and click **Add application**
In the following wizard enter the data for the application you want to add. See the data for the applications in the test environment in the table below.

| Application type    | Name       | Password   | URL                               | IP address    | Directories                                 | Authorisation |
| ------------------- | ---------- | ---------- | --------------------------------- | ------------- | ------------------------------------------- | ------------- |
| Jira                | jira       | jira       | http://192.168.56.31:8080         | 192.168.56.31 | Internal directory with OpenDevStack groups | all users     |
| Confluence          | confluence | confluence | http://192.168.56.31:8090         | 192.168.56.31 | Internal directory with OpenDevStack groups | all users     |
| Bitbucket Server    | bitbucket  | bitbucket  | http://192.168.56.31:7990         | 192.168.56.31 | Internal directory with OpenDevStack groups | all users     |
| Generic application | rundeck    | secret     | http://192.168.56.31:4440/rundeck | 192.168.56.31 | Internal directory with OpenDevStack groups | all users     |
| Generic application | provision  | provision  | http://127.0.0.1:8088             | 127.0.0.1     | Internal directory with OpenDevStack groups | all users     |

#### Bitbucket Setup

##### Setup Application

```
ansible-playbook -v -i inventories/dev playbooks/bitbucket.yml --ask-vault
```

##### Run Configuration Wizard

Access http://192.168.56.31:7990

Be patient. First time accessing this page takes some time.

On the configuration page you have the possibility to define the application name, the base URL and to get an evaluation license or enter a valid license.
If you choose to get an evaluation license you can retrieve it from the my atlassian page. You will be redirected automatically.
After adding the license you have to create a local Bitbucket administrator account.
Don't integrate Bitbucket with JIRA at this point, but proceed with going to Bitbucket.

##### Configure Crowd access
Go to the Bitbucket start page at http://192.168.56.31:7990/
Open the administration settings and navigate to the **User directories** menu.
Here you have to add a directory of type *Atlassian Crowd*.
Here you have to add the Crowd server URL `http://192.168.56.31:8095/crowd`
You also have to add the application name and the password you have defined for Bitbucket in crowd.
For the local test environment this is `bitbucket` `bitbucket`
Now activate **nested groups** and deactivate the **incremental synchronization**
The group membership should be proofed every time a user logs in.
Test the settings and save them.
Now change the order of the user directories. The Crowd directory has to be on first position.

##### Configure user groups
###### Add groups
After configuring the crowd directory change to **Groups**
Here you have to add the groups defined in crowd in the previous steps, if
they are not available yet.

| Group                    | Description                   |
| ------------------------ | ----------------------------- |
| bitbucket-administrators | Bitbucket administrator group |
| bitbucket-users          | Bitbucket user group          |

###### Add permissions
The last step is to configure the permissions for the created groups.
Go to the **Global permissions** menu.
In the groups section add the `bitbucket-administrators` group with *System Admin* rights.
Add the `bitbucket-users` group with *Project Creator* rights.

#### Jira Setup
##### Setup Application
```
ansible-playbook -v -i inventories/dev playbooks/jira.yml --ask-vault
```

##### Run Configuration Wizard
Access http://192.168.56.31:8080

Be patient. First time accessing this page takes time.

###### Step 1: Setup application properties
Here you have to choose the application title, the mode and the base URL.
You can leave the data as is for the test environment.

###### Step 2: Specify your license key
Here you have to enter the license key for the JIRA instance (Jira Software (Server)). With the provided link in the dialogue you are able to generate an evaluation license at Atlassian.

###### Step 3: Set up administrator account
Now you have to set up a JIRA administrator account.

###### Step 4: Set up email notifications
Unless you have configured a mail server, leave this for later.

###### Step 5: Basic configuration
To finish this part of the Jira installation, you will have to provide some informations to your prefered language, your avatar and you will have to create an empty or a sample project.
After these basic configurations, you have access to the Jira board.

##### Configure Crowd access

###### Configure user directory
Open the **User management** in the Jira administration.
To enter the administration, you have to verify you have admin rights with the password for your admin user.
Click the **User Directories** entry at the left..
Now choose **Add Directory**.
Here you have to add a directory of type *Atlassian Crowd*.
Here you have to add the Crowd server URL `http://192.168.56.31:8095/crowd`
You also have to add the application name and the password you have defined for Jira in crowd.
For the local test environment this is `jira` `jira`
Now activate **nested groups** and deactivate the **incremental synchronization**
The group membership should be proofed every time a user logs in.
Test the settings and save them.
Now change the order of the user directories. The Crowd directory has to be on first position.
###### Configure SSO with crowd
To finish the SSO configuration, you will have to run the following playbook command:
```
ansible-playbook -v -i inventories/dev playbooks/jira_enable_sso.yml --ask-vault
```
This will configure the authenticator.
**After Jira has been restarted, you are not able to login with the local administrator anymore, but with your crowd credentials.**

#### Confluence Setup

##### Setup Application
```
ansible-playbook -v -i inventories/dev playbooks/confluence.yml --ask-vault
```
##### Run Configuration Wizard
Access http://192.168.56.31:8090

###### Step 1: Set up Confluence
Here you have to choose **Production Installation**, because we want to configure an external database.

###### Step 2: Get add-ons
Ensure the add-ons are unchecked and proceed.

###### Step 3: License key
Here you are able to get an evaluation license from atlassian or to enter a valid license key.

###### Step 4: Choose a Database Configuration
Here you have to choose **External Database** with the option *PostgrSQL*

###### Step 5: Configure Database
Click the **Direct JDBC** button and configure the database with the following values:

| Option            | Value                                       |
| ----------------- | ------------------------------------------- |
| Driver Class Name | org.postgresql.Driver                       |
| Database URL      | jdbc:postgresql://localhost:5432/confluence |
| User Name         | confluence                                  |
| Password          | confluence                                  |

Be patient. This step takes some time until next page appears.

###### Step 6: Load Content
Here you have to choose **Empty Site** or **Example Site**

###### Step 7: Configure User Management
Choose **Manage users and groups within Confluence**. Crowd will be configured later.

###### Step 8: Configure System Administrator account
Here you have to configure a local administrator account. After this step, you are able to work with Confluence.

##### Configure Crowd access
###### Configure user directory
Open the **User management** in the Confluence administration.
To enter the administration, you have to verify you have admin rights with the password for your admin user.
Click the **User Directories** entry at the left in the **USERS & SECURITY** section.
Now choose **Add Directory**.
Here you have to add a directory of type *Atlassian Crowd*.
Here you have to add the Crowd server URL `http://192.168.56.31:8095/crowd`
You also have to add the application name and the password you have defined for Confluence in crowd.
For the local test environment this is `confluence` `confluence`
Now activate **nested groups** and deactivate the **incremental synchronization**
The group membership should be proofed every time a user logs in.
Test the settings and save them.
Now change the order of the user directories. The Crowd directory has to be on first position.

###### Configure SSO with crowd
To finish the SSO configuration, you will have to run the following playbook command:

```
ansible-playbook -v -i inventories/dev playbooks/confluence_enable_sso.yml --ask-vault
```
This will configure the authenticator.
**After Confluence has been restarted, you are not able to login with the local administrator anymore, but with your crowd credentials.**

#### Rundeck Setup
##### Setup Application
```
ansible-playbook -v -i inventories/dev playbooks/rundeck.yml --ask-vault
```
After the playbook has been finished Rundeck is accessible via http://192.168.56.31:4440/rundeck

### Configure Minishift
#### Minishift startup
First you have to install Minishift. You have to use a version <= 1.17.0, so openshift v3.6.1 (see below) is supported.

To do so, follow the installation instructions of the [Minishift Getting Started guide](https://docs.openshift.org/latest/minishift/getting-started/index.html "Getting Started with Minishift").

Before you start up Minishift with the `minishift start` command you will have to create or modify a `config.json` file.
This file is located in the `.minishift/config` folder in the user home directory.
On a Windows system, you will find this file under `C:\Users\<username>\.minishift\config\config.json`.
If the file doesn't exist, you will have to create it.
The file has to have the following content:
```javascript
{
    "cpus": 2,
    "memory": "8192",
    "openshift-version": "v3.6.1",
    "vm-driver": "virtualbox"
}
```
It is important to use *v3.6.1* to ensure, that the templates provided by the OpenDevStack work properly.
After the start up you are able to open the webconsole with the `minishift console` command. This will open the webconsole in your standard browser.
Please access the webconsole with the credentials `developer` `developer`.
It is *important* not to use the `system` user, because Jenkins does not allow a user named `system`.

#### Install the OC CLI
After you have accessed the webconsole, you have to open the question mark on the upper right corner and choose the **Command Line Tools**.
Follow the instructions to install the CLI. The following steps assume that the command line tools have been installed.
Please keep in mind to install the matching oc client version. In the above example, it would be the [oc client v3.6.1](https://github.com/openshift/origin/releases/tag/v3.6.1) version.

#### Login with the CLI
You have to login via the CLI with
```
oc login -u system:admin
```

#### Setup the base template project
After you have logged in, you are able to create a project, that will contain the base templates and the Nexus Repository Manager. Please enter the following command to add the base project:
```
oc new-project cd \
	--description="Base project holding the templates and the Repositoy Manager" --display-name="OpenDevStack Templates"
```
This command will create the base project.

#### Adjust user rights for the developer user
To be able to see all created projects, you will have to adjust the user rights for the developer use. Do so by using the provided command
```
oc adm policy --as system:admin add-cluster-role-to-user cluster-admin developer
```
#### Create service account for deployment
Rundeck needs a technical account in Minishift to be able to create projects and provision resources. Therefore, we create a service account, which credentials are provided to Rundeck in a later step.
```
oc create sa deployment -n cd
oc adm policy --as system:admin add-cluster-role-to-user cluster-admin system:serviceaccount:cd:deployment
```
After you have created the service account we need the token for this account.
```
oc sa get-token deployment -n cd
```
Save the token text. It will be used in the Rundeck configuration later.

#### Install Minishift certificate on Atlassian server
You have to add the Minishift certificate to the `atlassian1` JVM, so Bitbucket is able to execute REST Calls against Minishift, triggered by Webhooks.
Go to the directory, where you have started Vagrant.
Here open a SSH connection to the `atlassian1` server
```
vagrant ssh atlassian1
```
On the server change to the root account
```
sudo -i
```
Here execute the following command to get the certificate from the Minishift server:
```
openssl s_client -connect 192.168.99.100:8443 < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /tmp/minishift.crt
```

Ignore the error "verify error:num=19:self signed certificate in certificate chain". You should now have a PEM encoded certificate in /tmp/minishift.crt.

Now import the certificate in the default JVM keystore.
```
/usr/java/jdk1.8.0_172-amd64/jre/bin/keytool -import -alias minishift -keystore /usr/java/jdk1.8.0_172-amd64/jre/lib/security/cacerts -file /tmp/minishift.crt
```
The default password is `changeit`
Restart the bitbucket service
```
service atlbitbucket restart
```

### Setup and Configure Nexus3
#### Prepare in Minishift
The OpenDevStack Quickstarters assume, that you will have a Nexus3 Repository Manager in place to store the artifacts, generated during build. So we have to setup a Nexus3 in the bas project.
```
oc new-app sonatype/nexus3 -n cd
```

After creation change to the webconsole.
Access the base project "OpenDevStack Templates" and open the **Routes** section in the **Applications** tab.
Click **Create Route**
As name enter `nexus`.
You don't need to provide a hostname. Ensure, that the route points to the `nexus3` service with the correct port.
For the test environment we don't need save routes, so no change is needed here.
Click **Create** and the route is created. You should now be able to access Nexus 3 via http://nexus-cd.192.168.99.100.nip.io/

#### Add persistent claim
To have a stable state for the Repository Manager between several Minishift starts, you will have to add a persistent claim to the deployment.
First open the **Storage** menu and click **Create Storage**.
Define a name, e.g. `nexus3-pv` and define the size. 5GiB should last for testing purposes. Finish by clicking **Create**
Go to **Deployments** in the **Applications** menu, click the *nexus3* Deployment and choose the **Edit Yaml** action in the upper right corner in the **Actions** drop down.
Now replace the part
```
      volumes:
        - emptyDir: {}
          name: nexus3-volume-1
```
with
```
      volumes:
        - name: nexus3-volume-1
          persistentVolumeClaim:
            claimName: nexus3-pv
```
A new deployment will start with a mounted persistent volume.

#### Configure Repository Manager
Access Nexus3 http://nexus-cd.192.168.99.100.nip.io/
Login with the default credentials for Nexus3 `admin` `admin123`

##### Configure repositories
Open the **Server administration and configuration** menu.
Now create two Blob Stores.

| Type | Name             | Path                               |
| ---- | ---------------- | ---------------------------------- |
| File | candidates       | /nexus-data/blobs/candidates       |
| File | releases         | /nexus-data/blobs/releases         |
| File | atlassian_public | /nexus-data/blobs/atlassian_public |

After this you will have to create two hosted maven2 repositories in the **Repositories** Subsection.

| Name             | Format | Type   | Online  | Version policy | Layout policy | Storage    | Strict Content Type Validation | Deployment policy | Remote Storage                                                     |
| ---------------- | ------ | ------ | ------- | -------------- | ------------- | ---------- | ------------------------------ | ----------------- | ------------------------------------------------------------------ |
| candidates       | maven2 | hosted | checked | Release        | Strict        | candidates | checked                        | Disable-redeploy  |                                                                    |
| releases         | maven2 | hosted | checked | Release        | Strict        | releases   | checked                        | Disable-redeploy  |                                                                    |
| atlassian_public | maven2 | proxy  | checked | Release        | Strict        |            |                                |                   | https://maven.atlassian.com/content/repositories/atlassian-public/ |

Add the three repositories to the *maven-public* group.

##### Configure user and roles
First disable the anonymous access in the **Security > Anonymous** section.
Under **Security > Roles** create a role *OpenDevStack-Developer*.

| Role ID                | Role name              | Role description                  |
| ---------------------- | ---------------------- | --------------------------------- |
| opendevstack-developer | OpenDevStack-Developer | Role for access from OpenDevStack |

This role has to have the following privileges:

| Privilege                                    |
| -------------------------------------------- |
| nx-repository-admin-maven2-candidates-browse |
| nx-repository-admin-maven2-candidates-edit   |
| nx-repository-admin-maven2-candidates-read   |
| nx-repository-view-maven2-\*-\*              |
| nx-repository-view-maven2-candidates-\*      |

Now create a user under **Security > Users**.

| Name      | Password  |
| --------- | --------- |
| developer | developer |

TODO: Correct?
Make this account active and assign role `OpenDevStack-Developer` to this account.
END_TODO

### Import base templates
After you have configured Nexus3, import the base templates for OpenShift.
Clone the [ocp-templates repository](https://www.github.com/opendevstack/ocp-templates).
Navigate to the folder, where the cloned repository is located.
Navigate to the `scripts`subfolder.
From with this folder, check if you are still logged in to the OpenShift CLI and login, if necessary.
Now run the following shell script from within the `scripts`folder:
```
./upload-templates.sh
```
If not running under a cygwin environment, but with win-bash and bash located on your PATH, simply rundeck
```
bash ./upload-templates.sh
```
This creates the basic templates used by the OpenDevStack quickstarters in the `cd` project.
If you have to modify templates, there are also scripts to replace existing templates in OpenShift.

### Configure CD user
The continuous delivery process requires a dedicated system user in crowd for accessing bitbucket.
Access the [crowd console](http://192.168.56.31:8095/crowd/console/) and choose **Add user** in the **Users** menu.
Enter valid credentials. The only restriction here is, that the user has the username `cd_user` and that the user belongs to the internal crowd directory.
After creating the user you have to add the following group:

| Group              |
| ------------------ |
| opendevstack-users |

After you have created the user in crowd, you have to generate a SSH key for use in Rundeck.
Open the shell and generate a ssh key. On cygwig enter the following command:
```
ssh-keygen -f cd_user -t rsa -C "CD User"
```
This saves the public and private key in a file `cd_user.pub` and `cd_user`.
Open [Bitbucket](http://192.168.56.31:7990/), login with your crowd adminsitration user and go to the administration.
Here open the User section. If you can't see the CD user, you have to synchronize the Crowd directory in the **User directories** section.
Click on the CD user. In the user details you have the possiblity to add a SSH key. Click on the tab and enter the _public key_ from the generated key pair.

### Configure Rundeck
After configuring the Atlassian tools and Minishift, Rundeck has to be configured as well.
Access [Rundeck](http://192.168.56.31:4440/rundeck), login and open the configuration.

#### Create Quickstarters project
Create a project named `Quickstarters`. The project doesn't need any additional information, so leave all other options blank.

#### Openshift API token
You have to store the API token for the service account in Rundeck, so Rundeck is able to communicate with Openshift.

* In the **Key Storage** section click on **Add or Upload a Key**, choose the Key Type *Password*.
* Copy the token text you saved earlier to the textfield.
* Leave Storage path blank.
* The key has to have the name `openshift-api-token`
* Save the key.

#### CD user private key
For initial code commit the CD user's private key has to be stored in Rundeck, to enable an SSH communication between Rundeck and Bitbucket.

* In the **Key Storage** section click on **Add or Upload a Key**, choose the Key Type *Private key*.
* Enter / Upload the private key generated for the CD user.
* Leave Storage path blank.
* The key has to have the name `id_rsa_bitbucket`
* Save the key.

#### Configure SCM plugins
Open the configuration and go to the **SCM** section. This section is available as soon as you are in the project configuration for the `Quickstarters`project.

##### Setup Import plugin

* Change the **File Path Template** to `${job.group}${job.name}.${config.format}`
* Change the format for the **Job Source Files** to `yaml`
* Enter the SSH Git URL for the rundeck-projects repository, .
If you use the Github repository for the rundeck-projects no further configuration is needed.
If you use an own repository you have to enter valid authorization credentials, stored in Rundeck's key storage.
* In the next step ensure that the regular expression points to yaml files, if you want to use them.
* Import the job definitions.

##### Setup Export plugin
If you use the Github repository, this step isn't necessary.
If you use your own repository, configure the export plugin in same way as the import plugin.

### Configure provisioning application
Clone the provisioning application repository.
If you run the application from your IDE, there is no further configuration needed.

After startup via the IDE the application is available at http://localhost:8088/
## Try out the OpenDevStack
After you have set up your local environment it's time to test the OpenDevStack and see it working.
Open the Provisioning application in your web browser and login with your crowd credentials.
