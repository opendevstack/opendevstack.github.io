---
layout: documentation
---

# Getting started

## Introduction
Welcome to the OpenDevStack. The OpenDevStack is a framework to help in setting up a project infrastructure and continuous delivery processes on OpenShift and Atlassian toolstack with one click. This guide shall help you to setup the OpenDevStack, so you can work with it and test it in a local environment setup. The steps for the setup can also be adapted for running the OpenDevstack with an existing OpenShift installation or to connect it with your Atlassian tools, if you use [Atlassian Crowd](https://www.atlassian.com/software/crowd "Atlassian Crowd") as SSO provider.

**Important: The credentials provided in the guide are only meant to be used within the local test installation. For use in production you will have to customize paths, URLs and credentials!**

## Requirements
The following requirements have to be met to setup a local environment.
**Important: We assume, you will have a full functional internet connection**

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


### Cygwin / Linux

You must have the possibility to run bash scripts to install the OpenDevStack. On Linux systems you can use these scripts out-of-the box, on Windows systems you will have to install either a bash port for Windows like [Cygwin](https://www.cygwin.com/ "Cygwin").
For Windows, our recommendation is to use Cygwin for configuration. Make sure to select the curl package under the "net" category when installing cygwin.


### Ansible

The OpenDevStack uses [Ansible](https://www.ansible.com/ "Ansible") to install and configure the necessary software for the enabling stack, so it's recommended to get familiar with its core concepts and usage. Also credentials are stored within an Ansible vault, so even if you commit them in a public repository they are not available unless you know the vault password.

## Setup your local environment

From now on we assume, you work from a Bash (Cygwin / Linux).

### Tailor

We use [tailor](https://github.com/opendevstack/tailor) to handle our versioned OpenShift templates and keep our cluster in sync. Please see its [installation instructions](https://github.com/opendevstack/tailor#installation) for your platform. The following lists the version requirements:

| OpenDevStack version | Tailor version |
|---|---|
| 0.1.x | = 0.8 |
| 1.0.x | >= 0.9.1 |
| 1.1.x | >= 0.9.3 |

### Prepare infrastructure

First create a base directory for the OpenDevStack repositories, e.g. **ods**. This will be your base directory for all following operations.
This path will also be mounted to the VMs provisioned by Vagrant.

Then you have to clone the [ods-core](http://www.github.com/opendevstack/ods-core) repository into the created directory.
```
git clone https://github.com/opendevstack/ods-core.git
```
![Clone repository](../assets/documentation/clone_repo.PNG)

Navigate to the folder **ods > ods-core > infrastructure-setup**.

![Directory listing](../assets/documentation/scripts.PNG)

There you will find the setup and configuration shell scripts. You can start the infrastructure provisioning and setup by using
```shell
./setup-local-environment.sh
```
This script allows you to set the necessary installation pathes, clones the necessary OpenDevStack repositories and prepares the vagrant infrastructure, including the base installation of the Atlassian tools, Rundeck and datatbase preparing.

For a local test environment it is recommended to keep the default values.

![Configuration values](../assets/documentation/script-execution-1.PNG)

![Vagrant](../assets/documentation/script-execution-2.PNG)

During script execution you will have the possibility to choose, if you want to confirm the Atlassian and Rundeck installation for every tool or to run a complete setup.

![Atlassian stack](../assets/documentation/stack-confirm.PNG)

After the base installation, you will have to configure the Atlassian tools, before you are able to proceed.

![Vagrant](../assets/documentation/script-execution-3.PNG)

### Configure Atlassian Tools

The following steps explain the Atlassian tools configuration i the local test environment.
If you have already installed the Atlassian tools, you can skip the Configuration Wizard chapter for the respective tool

#### Atlassian Crowd 

##### Run Configuration Wizard

Access http://192.168.56.31:8095/crowd/console

Be patient. First time accessing this page will take some time.

###### Step 1: License key
Here you can see the server id you need for the license you can get from the [My Atlassian page](https://my.atlassian.com/products/index "My Atlassian"). Use the link to get an evaluation license (Crowd Server) or enter a valid license key into the textbox.

![License key](../assets/documentation/crowd/crowd-config-1.PNG)

###### Step 2: Crowd installation
Here choose the **New installation** option.

![New installation](../assets/documentation/crowd/crowd-config-2.PNG)

###### Step 3: Database Configuration
The next step is the database configuration.

![Database configuration](../assets/documentation/crowd/crowd-config-3.PNG)

Choose the **JDBC Connection** option and configure the database with the following settings

{: .table-bordered }
{: .table-sm }
| Option            | Value                                                                                                                |
| ----------------- | -------------------------------------------------------------------------------------------------------------------- |
| Database          | PostgreSQL                                                                                                           |
| Driver class name | org.postgresql.Driver                                                                                                |
| JDBC URL          | jdbc:postgresql://localhost:5432/crowd?reWriteBatchedInserts=true&amp;prepareThreshold=0 |
| Username          | crowd                                                                                                                |
| Password          | crowd                                                                                                                |
| Hibernate dialect | org.hibernate.dialect.PostgreSQLDialect                                                                              |

###### Step 4: Options
Choose a deployment title, e.g. *OpenDevStack* and set the **Base URL** to `http://192.168.56.31:8095/crowd`

![Options](../assets/documentation/crowd/crowd-config-4.PNG)

###### Step 5: Internal directory
Enter the name for the internal crowd directory, e.g. *OpenDevStack*

![Internal directory](../assets/documentation/crowd/crowd-config-5.PNG)

###### Step 6: Default administrator
Enter the data for the default administrator, so you are able to login to crowd. 
For the test installation, we will choose the username `opendevstack.admin` with the password `admin`.

![Default administrator](../assets/documentation/crowd/crowd-config-6.PNG)

###### Step 7: Integrated applications
Enable the OpenID Server.

![Integrated applications](../assets/documentation/crowd/crowd-config-7.PNG)

###### Step 8: Log in to Crowd console
Now you can verify the installation and log in with the credentials defined in the previous step.

![Login](../assets/documentation/crowd/crowd-config-8.PNG)

##### Configure Crowd
You will have to configure crowd to enable the Atlassian tools and Rundeck to login with crowd credentials. 

The following paragraphs assume, that you are logged in to the [Crowd console](http://192.168.56.31:8095/crowd/console). 

###### Session configuration
You will have to change the default session configuration.

Open the **Administration** menu and choose the **Session configuration** entry.

![Session configuration](../assets/documentation/crowd/crowd-session-configuration.PNG)

Uncheck the **Require consistent client IP address** checkbox.

![Session configuration](../assets/documentation/crowd/crowd-session-configuration-2.PNG)

Click **save** and login again.

![Session configuration success](../assets/documentation/crowd/crowd-session-configuration-3.PNG)

###### Add OpenDevStack groups
You will have to add additional groups Crowd's internal directory. The groups are listed in the table below.

{: .table-bordered }
{: .table-sm }
| Group                       | Description                                         |
| --------------------------- | --------------------------------------------------- |
| opendevstack-users          | Group for normal users without adminstration rights |
| opendevstack-administrators | Group for administration users                      |

To add a group, open the **Groups** tab and choose **Add group**

![Add group](../assets/documentation/crowd/crowd-add-group.PNG)

Enter the name and the description for the group, choose the **OpenDevStack** directory and click **Create**.

![Enter group details](../assets/documentation/crowd/crowd-add-group-2.PNG)

The group has been created. Repeat the steps of group creation for all necessary groups.

###### Add CD user
After creating the groups you have to create a user, that is used by continuous integration mechanisms of the OpenDevStack.

Go to the **Users** section in Crowd and click **Add user**.

![Add user](../assets/documentation/crowd/crowd-add-user-1.PNG)

Enter the details for the CD user and click **Create**. For the provided scripts we assume, that the username `cd_user` with the password `cd_user` is used.

![User details](../assets/documentation/crowd/crowd-add-user-2.PNG)

In the following overview choose the user's **group** tab and click **Add groups**

![User group tab](../assets/documentation/crowd/crowd-add-user-3.PNG)

Now search for all groups by leaving the Search fields empty, check the **opendevstack-users** group and click **Add selected groups**.

![Group modal view](../assets/documentation/crowd/crowd-add-user-4.PNG)

The group has been added to the user.

![Updated user groups](../assets/documentation/crowd/crowd-add-user-5.PNG)

###### Add groups to administrator
Now you have to add all groups to the administrator.
Go to the **Users** section in Crowd, choose your administration user and open the **Groups** tab.
Click **Add groups**, search for all by leaving the Search fields empty and add all groups.

![Administrator groups](../assets/documentation/crowd/crowd-add-user-6.PNG)

###### Add applications to crowd
You will have to add the applications you want to access with your Crowd credentials in the Crowd console.

Access the Crowd console at http://192.168.56.31:8095/crowd/console/

*The following example shows, how to add Jira to the application section. The steps for the other applications are equal.*

Choose the **Applications** menu point and click **Add application**

![Add application](../assets/documentation/crowd/crowd-add-app-1.PNG)

You enter the _Add application_-Wizard. Enter your application details and proceed with **Next**.

![Add application - details](../assets/documentation/crowd/crowd-add-app-2.PNG) 

Enter the _URL_ and _Remote IP address_ and click **Next**.
 
![Add application - connection](../assets/documentation/crowd/crowd-add-app-3.PNG)   

Check the OpenDevStack user directory checkbox. Then proceed with **Next**.

![Add application - directory](../assets/documentation/crowd/crowd-add-app-4.PNG) 

Check the _Allow all users to authenticate_ checkbox. Click **Next**.

![Add application - authorisation](../assets/documentation/crowd/crowd-add-app-5.PNG) 

Confirm the application information by clicking **Add application**

![Add application - confirmation](../assets/documentation/crowd/crowd-add-app-6.PNG) 

In the following overview choose the **Remote addresses** tab.

![Add application - remote addresses](../assets/documentation/crowd/crowd-add-app-7.PNG)

Now enter the CIDR `0.0.0.0/0` in the input field and click **Add**.

![Add application remote addresses](../assets/documentation/crowd/crowd-add-app-8.PNG)

You will have to add all applications listed in the table below. The provided data is meant to be used in the local test environment.

{: .table-bordered }
{: .table-sm }
| Application type    | Name       | Password   | URL                               | IP address    | Directories                                 | Authorisation | Additional Remote Adresses |
| ------------------- | ---------- | ---------- | --------------------------------- | ------------- | ------------------------------------------- | ------------- | -------------------------- |
| Jira                | jira       | jira       | http://192.168.56.31:8080         | 192.168.56.31 | Internal directory with OpenDevStack groups | all users     | 0.0.0.0/0 |
| Confluence          | confluence | confluence | http://192.168.56.31:8090         | 192.168.56.31 | Internal directory with OpenDevStack groups | all users     | 0.0.0.0/0 |
| Bitbucket Server    | bitbucket  | bitbucket  | http://192.168.56.31:7990         | 192.168.56.31 | Internal directory with OpenDevStack groups | all users     | 0.0.0.0/0 |
| Generic application | rundeck    | rundeck     | http://192.168.56.31:4440 | 192.168.56.31 | Internal directory with OpenDevStack groups | all users     | 0.0.0.0/0 |
| Generic application | provision  | provision  | http://192.168.56.1:8088             | 192.168.56.1  | Internal directory with OpenDevStack groups | all users     | 0.0.0.0/0 |
| Generic application | sonarqube  | sonarqube  | https://sonarqube-cd.192.168.56.101.nip.io| 192.168.56.101  | Internal directory with OpenDevStack groups | all users     | 0.0.0.0/0 |

After adding all applications they should shown at the applications overview in Crowd.

![Applications overview](../assets/documentation/crowd/crowd-app-overview.PNG)

#### Attlassian Bitbucket

##### Run Configuration Wizard

Access http://192.168.56.31:7990

Be patient. First time accessing this page takes some time.

On the configuration page you have the possibility to define the application name, the base URL and to get an evaluation license or enter a valid license.
If you choose to get an evaluation license you can retrieve it from the my atlassian page. You will be redirected automatically.

![Bitbucket setup - licensing](../assets/documentation/bitbucket/bitbucket-install-1.PNG)

After adding the license you have to create a local Bitbucket administrator account.

![Bitbucket setup - administrator](../assets/documentation/bitbucket/bitbucket-install-2.PNG)

Don't integrate Bitbucket with Jira, but proceed with going to Bitbucket.

##### Configure Crowd access
Go to the Bitbucket start page at http://192.168.56.31:7990/
Open the administration settings and navigate to the **User directories** menu.

![Add directory](../assets/documentation/bitbucket/bitbucket-add-directory-1.PNG)

Here you have to add a directory of type *Atlassian Crowd*.
In the following form add the Crowd server URL `http://192.168.56.31:8095/crowd`, the application name and the password you have defined for Bitbucket in crowd.
For the local test environment this is `bitbucket` `bitbucket`
Now activate **nested groups** and deactivate the **incremental synchronization**
The group membership should be proofed every time a user logs in.
Test the settings and save them.

![Add directory - form](../assets/documentation/bitbucket/bitbucket-add-directory-2.PNG)

Now change the order of the user directories. The Crowd directory has to be on first position.
Synchronize the directory, so all groups and users are available in Bitbucket.

![User directory listing](../assets/documentation/bitbucket/bitbucket-add-directory-3.PNG)

###### Add permissions
Now you have to configure the permissions for the OpenDevStack groups.
Go to the **Global permissions** menu.

![Add permission](../assets/documentation/bitbucket/bitbucket-add-permission-1.PNG)

In the _Group access_ section add the `opendevstack-administrators` group with *System Admin* rights.

![Add permission - administrators](../assets/documentation/bitbucket/bitbucket-add-permission-2.PNG)

Add the `opendevstack-users` group with *Project Creator* rights.

![Add permission - users](../assets/documentation/bitbucket/bitbucket-add-permission-3.PNG)

###### Create OpenDevStack project in Bitbucket
The local checked out OpenDevStack repositories will be mirrored into the Bitbucket instance.
Therefore, we need to create a new _project_ within Bitbucket.

Go to the Projects page in Bitbucket and click the **Create project** button.

![project overview](../assets/documentation/bitbucket/bitbucket-add-project-1.PNG)

Now enter the _Project name:_ `OpenDevStack` with the _Project key_ `OPENDEVSTACK` and hit 
**Create Project**.

![Create project form](../assets/documentation/bitbucket/bitbucket-add-project-2.PNG)

Now open the project settings.

![Project details](../assets/documentation/bitbucket/bitbucket-project-settings-1.PNG)

In the **Project permissions** section, allow the `opendevstack-users` group write access.

![Project permissions](../assets/documentation/bitbucket/bitbucket-project-settings-2.PNG)

After you have adjusted the project permissions, you will have to create the repositories for the OpenDevStack.
Go to the OpenDevStack project overview and choose the **Create repository** option, either with 
the '+' sign on the left menu bar or with the **Create repository** button in the middle of the screen, 
if you have an empty project.

![Project overview](../assets/documentation/bitbucket/bitbucket-add-repo-1.PNG)

Enter the name for the repository and click **Create repository**.

![Project overview](../assets/documentation/bitbucket/bitbucket-add-repo-2.PNG)

You will have to create the repositories listed in the table below.

{: .table-bordered }
{: .table-sm }
| Repositories                |
| --------------------------- |
| ods-core                    |
| ods-configuration           |
| ods-configuration-sample    |
| ods-jenkins-shared-library  |
| ods-project-quickstarters   |
| ods-provisioning-app        |


###### Add SSH Key for CD user to Bitbucket
![Add SSH key](../assets/documentation/bitbucket/bitbucket-add-ssh-key-1.PNG)
![Add SSH key](../assets/documentation/bitbucket/bitbucket-add-ssh-key-2.PNG)
![Add SSH key](../assets/documentation/bitbucket/bitbucket-add-ssh-key-3.PNG)
![Add SSH key](../assets/documentation/bitbucket/bitbucket-add-ssh-key-4.PNG)
![Add SSH key](../assets/documentation/bitbucket/bitbucket-add-ssh-key-5.PNG)
![Add SSH key](../assets/documentation/bitbucket/bitbucket-add-ssh-key-6.PNG)

#### Atlassian Jira

##### Run Configuration Wizard
Access http://192.168.56.31:8080

Be patient. First time accessing this page takes time.

###### Step 1: Setup application properties
Here you have to choose the application title and the base URL.
You can leave the data as is for the test environment.

###### Step 2: Specify your license key
Here you have to enter the license key for the Jira instance (Jira Software (Server)). With the provided link in the dialogue you are able to generate an evaluation license at Atlassian.

###### Step 3: Set up administrator account
Now you have to set up a Jira administrator account.

###### Step 4: Set up email notifications
Unless you have configured a mail server, leave this for later.

###### Step 5: Basic configuration
To finish this part of the Jira installation, you will have to provide some informations to your prefered language, your avatar and you will have to create an empty or a sample project.
After these basic configurations, you have access to the Jira board.

##### Configure user directory
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
Synchronize the directory, so all groups and users are available in Jira.

##### Add permissions
The last step is to configure the permissions for the OpenDevStack groups.

#### Atlassian Confluence

##### Run Configuration Wizard
Access http://192.168.56.31:8090

###### Step 1: Set up Confluence
Here you have to choose **Production Installation**, because we want to configure an external database.

###### Step 2: Get add-ons
Ensure the add-ons are unchecked and proceed.

###### Step 3: License key
Here you are able to get an evaluation license from atlassian or to enter a valid license key.

###### Step 4: Choose a Database Configuration
Here you have to choose **External Database** with the option *PostgreSQL*

###### Step 5: Configure Database
Click the **Direct JDBC** button and configure the database with the following values:

{: .table-bordered }
{: .table-sm }
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
Here you have to configure a local administrator account. After this step, you are able to work with Confluence. Just press Start and create a space.

##### Configure user directory
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

##### Add permissions
The last step is to configure the permissions for the OpenDevStack groups.





###Prepare local OpenDevStack environment
Navigate to the **ods-core/infrastructure-setup/scripts** directory and execute
`mirror-repos.sh`

Use your crowd login when asked for credentials.
Verify that you have mirrored the github repos and that they have been populated in your Bitbucket instance. The ods-configuration repositpory will remain empty.

Setup project branch permissions - `production` should be guarded against direct merges except through admins

####Nexus3
Nexus3 will be installed automatically, if you have confirmed the installation in the prepare script.

After the installation Nexus3 will be accessible at http://nexus-cd.192.168.56.101.nip.io/

You are able to login with the default credentials for Nexus3 `admin` `admin123`.

During installation various resources will be created automatically. You will find their description in 
the subsequent paragraphs.

#####Blob stores
In the automated installation the following blob stores will be created

| Type | Name             | Path                               |
| ---- | ---------------- | ---------------------------------- |
| File | candidates       | /nexus-data/blobs/candidates       |
| File | releases         | /nexus-data/blobs/releases         |
| File | atlassian_public | /nexus-data/blobs/atlassian_public |

#####Repositories
This table lists the repositories created automatically.

| Name             | Format | Type   | Online  | Version policy | Layout policy | Storage    | Strict Content Type Validation | Deployment policy | Remote Storage | belongs to group                                                    |
| ---------------- | ------ | ------ | ------- | -------------- | ------------- | ---------- | ------------------------------ | ----------------- | ------------------------------------------------------------------ | ------------ |
| candidates       | maven2 | hosted | checked | Release        | Strict        | candidates | checked                        | Disable-redeploy  | | none                                                                   |
| releases         | maven2 | hosted | checked | Release        | Strict        | releases   | checked                        | Disable-redeploy  | | none                                                                   |
| npmjs           | npm     | proxy  | checked |                |               | default    | checked                        |   |  https://registry.npmjs.org  | |
| atlassian_public | maven2 | proxy  | checked | Release        | Strict        | atlassian_public  | checked                 | Disable-redeploy  | https://maven.atlassian.com/content/repositories/atlassian-public/ |
| jcenter | maven2 | proxy  | checked | Release        | Strict        | default  | checked                 | Disable-redeploy  | https://jcenter.bintray.com | maven-public
| sbt-plugins | maven2 | proxy  | checked | Release        | permissive | default  | unchecked                 | Disable-redeploy  | http://dl.bintray.com/sbt/sbt-plugin-releases/ | ivy-releases
| sbt-releases | maven2 | proxy  | checked | Release        | permissive | default  | unchecked                 | Disable-redeploy  | https://repo.scala-sbt.org/scalasbt/sbt-plugin-releases | ivy-releases
| typesafe-ivy-releases | maven2 | proxy  | checked | Release        | permissive | default  | unchecked                 | Disable-redeploy  | https://dl.bintray.com/typesafe/ivy-releases | ivy-releases
| ivy-releases | maven2 | group  | checked | Release        | permissive | default  | unchecked                 | Disable-redeploy  | |
| pypi-all | pypi | group  | checked |         |  | default  |                 | |  | pypi-proxy |  
| pypi-proxy | pypi | proxy  | checked |         |  | default  |                |  | https://pypi.org/ | |

#####User and roles
During installation the following user will be created.

| Name      | Password  |
| --------- | --------- |
| developer | developer |

The user will get the `opendevstack-developer` role listed below.

| Role ID                | Role name              | Role description                  |
| ---------------------- | ---------------------- | --------------------------------- |
| opendevstack-developer | OpenDevStack-Developer | Role for access from OpenDevStack |

This role has the following privileges:

| Privilege                                    |
| -------------------------------------------- |
| nx-repository-admin-maven2-candidates-browse |
| nx-repository-admin-maven2-candidates-edit   |
| nx-repository-admin-maven2-candidates-read   |
| nx-repository-view-maven2-\*-\*              |
| nx-repository-view-maven2-candidates-\*      |
| nx-repository-view-npm-\*-\* |

The account created is used to authenticate against Nexus3, anonymous access is disabled.

####Sonarqube
####Rundeck configuration

#### Rundeck Setup
##### Setup Application
Rundeck needs an account to access Bitbucket later. We will create an ssh keypair for this and add this later to the Bitbucket `cd_user` account.

Open the shell and generate a ssh key. On cygwin enter the following command:
```shell
ssh-keygen -f /home/vagrant/cd_user -t rsa -C "CD User"
```
This saves the public and private key in a file `cd_user.pub` and `cd_user`.


Create a file called `/home/vagrant/rundeck_vars.yml` that customizes some of the rundeck configuration, e.g. the ssh key.

This is a yaml file, looking structurally like this Example

```yaml
rundeck_bitbucket_host_external: 192.168.56.31
rundeck_bitbucket_host_internal: localhost
rundeck_bitbucket_port: 7999
rundeck_cduser_name: cd_user
rundeck_cduser_private_key: |
  -----BEGIN RSA PRIVATE KEY-----
  MIIJKgIBAAKCAgEA9byVUZKe0dB0gkFL5g4Zcxb3AUNPvtD2tpkejyaLoF/XnQj+
  qn+UX9WZSn0YyTQH+cmNF1SFuMmq/eSZpdAL7JSRY2bAw9RLo3dPpabO2N3Teib1
  HSvCnPncNQZa/tPUaWSddX0BTWEpS1fAl4NFfUmN02k+cEHIErv2OcbhMnq675aO
  p4rU3NHN01kymhUCLz5cUCAj4CyEhxv3Fe7zSeKGuSceaD2Yq1vEnp8WmYnqdiFf
  ....
  0rMrGoSgTuttxQ+oU2a+2pRQD+vFXg6BpXMJNXeXyPuSIVfqfSFTqUdshZC8d76Q
  8IwfUR/GtEjTO4l9nDr0eqb4LixvpREVVvMOH+Ea/a8yATejH9xR7xNHAA0AQqZ+
  t1pNCqijBNTk2oUYNu9t9m16zF3Ly+ZIikBm0D67ke5yC5ziSPa1Xs6E70ens04H
  RwP9We5Y453L2st43FlQXVAyXd4OacJcUqvYqQpd7c7u1syhpRzG5ALYcfoNJA==
  -----END RSA PRIVATE KEY-----
```

You have to replace the private key with the key you created earlier and change
other variables according to your environment. Be careful about the 2 spaces at the beginning of every line of the private key.

Now execute the playbook:

```shell
ansible-playbook -v -i inventories/dev playbooks/rundeck.yml -e "@/home/vagrant/rundeck_vars.yml" --ask-vault
```

You can change `host` and `cduser` according to your environment.
<!-- TODO
This is superfluous if we mirror the repos first to our vagrant / local bitbucket server.
-->
After the playbook has been finished Rundeck is accessible via http://192.168.56.31:4440/rundeck



### Prepare CD project for Jenkins

Now create secrets inside the CD project.

```shell
oc process -n cd templates/secrets -p PROJECT=cd | oc create -n cd -f-
```

We will now build base images for jenkins and jenkins slave:

* Customize the configuration in the `ods-configuration` project at **ods-core > jenkins > ocp-config > bc.env**
* Execute `tailor update` inside ods-core/jenkins/ocp-config:

* Start jenkins slave base build: `oc start-build -n cd jenkins-slave-base`
* check that builds for `jenkins-master` and `jenkins-slave-base` are running and successful.
* You can optionally start the `jenkins-master` build using `oc start-build -n cd jenkins-master`

#### Prepare Jenkins slave docker images
To support different kinds of projects, we need different kinds of Jenkins slave images.
These slave images are located in the project [jenkins-slave-dockerimages](https://github.com/opendevstack/jenkins-slaves-dockerimages).

So as a first step clone this repository.
Make the required customizations in the `ods-configuration` under **jenkins-slaves-dockerimages > maven > ocp-config > bc.env**

and run `tailor update` inside `ods-project-quickstarters\jenkins-slaves\maven\ocp-config`:

and start the build: `oc start-build -n cd jenkins-slave-maven`.

Repeat for every project type you require.





### Prepare Rundeck and required Dockerfiles

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

Within the ods-project-quickstarters create a new branch called `rundeck-changes` - and let it inherit from production
<!--
TODO: verify the branch source is correct!
END_TODO
-->

Open the configuration and go to the **SCM** section. This section is available as soon as you are in the project configuration for the `Quickstarters` project.

##### Setup Import plugin

* Change the **File Path Template** to `${job.group}${job.name}.${config.format}`
* Change the format for the **Job Source Files** to `yaml`
* Enter the SSH Git URL for the `ods-project-quickstarters` repository.
You have to enter valid authorization credentials, stored in Rundeck's key storage. This will be the ` id_rsa_bitbucket` key specified in the previous step.
* Branch: Choose "rundeck-changes"
* In the next step ensure that the regular expression points to yaml files. Change the regexp to `rundeck-jobs/.*\.yaml`
* Change the file path template to `rundeck-jobs${job.group}${job.name}-${job.id}.${config.format}`
* Import the job definitions under job actions.


##### Setup Export plugin
If you use the Github repository, and use as is this step isn't necessary!
If you use your own repository, configure the export plugin in same way as the import plugin, except the file path template - set to `rundeck-jobs/${job.group}${job.name}.${config.format}`

##### Update the job properties

Go to the project page and then configure. Edit the configuration file (using the button) and add the following lines - based on your environment

```INI
# bitbucket https host including url schema
project.globals.bitbucket_host=https\://192.168.56.31
# bitbucket ssh host including url schema
project.globals.bitbucket_sshhost=ssh://git@192.168.56.31:7999
# openshift host including url scheme
project.globals.openshift_apihost=https://192.168.99.100:8443
# openshift host without url scheme - used to grab CA etc
project.globals.openshift_apihost_lookup=192.168.99.100:8443
# openshift nexus host including url scheme
project.globals.nexus_host=http://nexus-cd.192.168.99.100.nip.io/
# public route of docker registry including url scheme
project.globals.openshift_dockerregistry=https://docker-registry-default.192.168.99.100.nip.io:443
# os user and group rundeck is running with
project.globals.rundeck_os_user=root:root
```
### Add shared images
OpenDevStack provides shared images used accross the stack - like the authproxy based on NGINX and lua for crowd

In order to install, create a new project called `shared-services`

Make the required customizations in the `ods-configuration` under **ods-core > shared-images > nginx-authproxy-crowd >  ocp-config > bc.env and secret.env**

and run `tailor update` inside `ods-core\shared-images\nginx-authproxy-crowd`:

and start the build: `oc start-build -n shared-services nginx-authproxy`.

### Configure provisioning application
Clone the provisioning application repository.

Because we disabled anonymous access for nexus, we need to provide some data.

What you need to provide are gradle guild variables. You do this by creating a `gradle.properties` file in the ods-provisioning-app project:

```INI
nexus_url=http://nexus-cd.192.168.99.100.nip.io
nexus_user=developer
nexus_pw=developer
```

If you run the application from your IDE, there is no further configuration needed.

After startup via the IDE the application is available at http://localhost:8088/

You can login in with the Crowd admin user you set up earlier.

### Setup within Openshift

Create 3 openshift projects projects
- `prov-cd` (for the jenkins builder)
- `prov-test` (*production* branch will be built and deployed here)
- `prov-dev` (other branches will be built and deployed here)

Start with `prov-cd` and issue:
```
cd ocp-config/prov-cd
tailor update
```

Add `prov-cd/jenkins` and `prov-cd/default` service accounts with edit rights into -dev & -test projects, so jenkins can update the build config and trigger the corresponding `oc start build / oc update bc` from within the jenkins build.

For the runtime projects (`prov-test` and `prov-dev`) run:
```shell
cd ocp-config/prov-app
tailor update -f Tailorfile.dev
tailor update -f Tailorfile.test
```

Once Jenkins id deployed, you can trigger the build in the `prov-cd/ods-provisioning-app-production` pipeline. Deployment should happen automatically and you can start using the provision app.


## Try out the OpenDevStack
After you have set up your local environment it's time to test the OpenDevStack and see it working.
Open the Provisioning application in your web browser and login with your crowd credentials.

Provision your first project and have a look at OpenShift.
