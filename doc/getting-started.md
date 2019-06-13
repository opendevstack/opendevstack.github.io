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
![Clone repository](../assets/documentation/setup-script/clone_repo.PNG)

Navigate to the folder **ods > ods-core > infrastructure-setup**.

![Directory listing](../assets/documentation/setup-script/scripts.PNG)

There you will find the setup and configuration shell scripts. You can start the infrastructure provisioning and setup by using
```shell
./setup-local-environment.sh
```
This script allows you to set the necessary installation pathes, clones the necessary OpenDevStack repositories and prepares the vagrant infrastructure, including the base installation of the Atlassian tools, Rundeck and datatbase preparing.

For a local test environment it is recommended to keep the default values.

![Configuration values](../assets/documentation/setup-script/script-execution-1.PNG)

![Vagrant](../assets/documentation/setup-script/script-execution-2.PNG)

During script execution you will have the possibility to choose, if you want to confirm the Atlassian and Rundeck installation for every tool or to run a complete setup.

![Atlassian stack](../assets/documentation/setup-script/stack-confirm.PNG)

After the base installation, you will have to configure the Atlassian tools, before you are able to proceed.

![Vagrant](../assets/documentation/setup-script/script-execution-3.PNG)

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

![Setup application properties](../assets/documentation/jira/jira-install-1.PNG)

###### Step 2: Specify your license key
Here you have to enter the license key for the Jira instance (Jira Software (Server)). With the provided link in the dialogue you are able to generate an evaluation license at Atlassian.

![License key](../assets/documentation/jira/jira-install-2.PNG)

###### Step 3: Set up administrator account
Now you have to set up a Jira administrator account.

![Local Jira administrator](../assets/documentation/jira/jira-install-3.PNG)

###### Step 4: Set up email notifications
Unless you have configured a mail server, leave this for later.

![email notifications](../assets/documentation/jira/jira-install-4.PNG)

###### Step 5: Basic configuration
To finish this part of the Jira installation, you will have to provide some informations to your prefered language, your avatar and you will have to create an empty or a sample project.

![Language selection](../assets/documentation/jira/jira-install-5.PNG)

![Avatar selection](../assets/documentation/jira/jira-install-6.PNG)

![Example project](../assets/documentation/jira/jira-install-7.PNG)

After these basic configurations, you have access to the Jira board.

##### Configure user directory
Open the **User management** in the Jira administration.
To enter the administration, you have to verify you have admin rights with the password for your admin user.

![Administration access](../assets/documentation/jira/jira-user-directory-1.PNG)

Click the **User Directories** entry at the left.

![User directories](../assets/documentation/jira/jira-user-directory-2.PNG)

Now choose **Add Directory**.
Here you have to add a directory of type *Atlassian Crowd*.
Enter the Crowd server URL `http://192.168.56.31:8095/crowd`
You also have to fill in the application name and the password you have defined for Jira in crowd.

For the local test environment this is `jira` `jira`.

Now activate **nested groups** and deactivate the **incremental synchronization**
The group membership should be proofed every time a user logs in.
Test the settings and save them.

![User directory form](../assets/documentation/jira/jira-user-directory-3.PNG)

Now change the order of the user directories. The Crowd directory has to be on first position.
Synchronize the directory, so all groups and users are available in Jira.

![Directory listing](../assets/documentation/jira/jira-user-directory-4.PNG)

##### Add permissions
The last step is to configure the permissions for the OpenDevStack user groups.
Go to the _Global Permissions_ menu beneath the _System_ tab.

![Global permissions](../assets/documentation/jira/jira-permissions-1.PNG)

There you will have to add the OpenDevStack groups according to the Jira user groups. 
For this choose the permission and the user group in the _Add Permission_ section of the page and click **Add**. 

![Global permissions with added OpenDevStack groups](../assets/documentation/jira/jira-permissions-2.PNG)

See the table below for the permission mapping.

{: .table-bordered }
{: .table-sm }
| Permission                  | User group                  |
| --------------------------- | --------------------------- |
| Jira System Administrators  | opendevstack-administrators |
| Jira Administrators         | opendevstack-administrators |
| Browse Users                | opendevstack-(administrators|users) |
| Create Shared Objects       | opendevstack-(administrators|users) |
| Manage Group Filter Subscriptions | opendevstack-(administrators|users) |
| Bulk Change                 | opendevstack-(administrators|users) |

#### Atlassian Confluence

##### Run Configuration Wizard
Access http://192.168.56.31:8090

###### Step 1: Set up Confluence
Here you have to choose **Production Installation**, because we want to configure an external database.

![Set up Confluence](../assets/documentation/confluence/confluence-install-1.PNG)

###### Step 2: Get add-ons
Ensure the add-ons are unchecked and proceed.

![Add-Ons](../assets/documentation/confluence/confluence-install-2.PNG)

###### Step 3: License key
Here you are able to get an evaluation license from atlassian or to enter a valid license key.

![License key](../assets/documentation/confluence/confluence-install-3.PNG)

###### Step 4: Choose a Database Configuration
Here you have to choose **My own database**.

![Database selection](../assets/documentation/confluence/confluence-install-4.PNG)

###### Step 5: Configure Database
Choose **By connection string** as _Setup type_ and configure the database with the following values:

{: .table-bordered }
{: .table-sm }
| Option            | Value                                       |
| ----------------- | ------------------------------------------- |
| Database Type     | PostgreSQL                                  |
| Database URL      | jdbc:postgresql://localhost:5432/confluence |
| User Name         | confluence                                  |
| Password          | confluence                                  |

![Database configuration](../assets/documentation/confluence/confluence-install-5.PNG)

Click **Next** to proceed.

Be patient. This step takes some time until next page appears.

###### Step 6: Load Content
Here you have to choose **Empty Site** or **Example Site**

![Load content](../assets/documentation/confluence/confluence-install-6.PNG)

###### Step 7: Configure User Management
Choose **Manage users and groups within Confluence**. Crowd will be configured later.

![Configure user management](../assets/documentation/confluence/confluence-install-7.PNG)

###### Step 8: Configure System Administrator account
Here you have to configure a local administrator account. After this step, you are able to work with Confluence. Just press Start and create a space.

![Configure administrator account](../assets/documentation/confluence/confluence-install-8.PNG)

##### Configure user directory
Open the **User management** in the Confluence administration.

To enter the administration, you have to verify you have admin rights with the password for your admin user.

Click the **User Directories** entry at the left in the **USERS & SECURITY** section.

Now choose **Add Directory**.

![Add user directory](../assets/documentation/confluence/confluence-user-directory-1.PNG)

Here you have to add a directory of type *Atlassian Crowd*.

Now enter the Crowd server URL `http://192.168.56.31:8095/crowd`

You also have to fill in the application name and the password you have defined for Confluence in crowd.

For the local test environment this is `confluence` `confluence`

Activate **nested groups** and deactivate the **incremental synchronization**

The group membership should be proofed every time a user logs in.

Test the settings and save them.

![User directory form](../assets/documentation/confluence/confluence-user-directory-2.PNG)

Now change the order of the user directories. The Crowd directory has to be on first position and synchronize the directory.

![User directory listing](../assets/documentation/confluence/confluence-user-directory-3.PNG)

##### Add permissions
The last step is to configure the permissions for the OpenDevStack groups.

Open the **User management** in the Confluence administration.

To enter the administration, you have to verify you have admin rights with the password for your admin user.

![Administration login](../assets/documentation/confluence/confluence-permission-1.PNG)

Click the **Global Permissions** entry at the left in the **USERS & SECURITY** section.

![Permission listing](../assets/documentation/confluence/confluence-permission-2.PNG)

Now choose **Edit Permissions** and add the OpenDevStack groups with the Input field in the groups section.

![Add group to permissions](../assets/documentation/confluence/confluence-permission-3.PNG)

Check the checkboxes, so the OpenDevStack groups have the same permissions the local confluence groups have.

![Set permissions](../assets/documentation/confluence/confluence-permission-4.PNG)

Click **Save all** to persist the permissions.

###Prepare local OpenDevStack environment
After the configuration of the Atlassian tools has been done, it's time to continue with the preparation oft the OpenDevStack environment.
In this step the basic configuration for the OpenShift cluster takes place, as well as the installation of Sonarqube, Nexus3 and the Provisioning application.
In addition Rundeck will be prepared automatically as far as possible.

Navigate to the **ods-core/infrastructure-setup/scripts** directory on your local machine and execute the script
 
`prepare-local-environment.sh`

![Directory listing](../assets/documentation/prepare-script/directory-listing.PNG)

Now you will have to decide, which configuration should be done. In a first time installation you will have to keep the defaults.
For further customization there will be an additional guide.

**Important; The preparation script also activates SSO in Confluence and Jira. After the activation has been done a login with the local administrator credentials is no longer possible!**

![SSO activation](../assets/documentation/prepare-script/activate-sso.PNG)

During the mirroring of the local repositories to your Bitbucket instance, it is possible, that you will be asked for credentials.
Here you have to enter the credentials for your loacl Crowd administrator or the `cd_user` credentials.

![Git credentials](../assets/documentation/prepare-script/git-credentials.PNG)

After the repository mirroring you may setup project branch permissions in Bitbucket, if the `production` branch should be guarded against direct merges except through admins.

The subsequent paragraphs explain the installation and configuration content for Nexus3, Sonarqube, Rundeck and the Provisioning application.

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
By default Sonarqube will be installed with the preparation script.

You will have to pass a valid authentication token for Sonarqube to the OpenShift templates, so the script will pause as soon as Sonarqube is available.

![Paused preparation script](../assets/documentation/sonarqube/pause-script.PNG)

Go to https://sonarqube-cd.192.168.56.101.nip.io .

![Sonarqube Screen](../assets/documentation/sonarqube/sonarqube_login.PNG)

Login with your Crowd credentials.

![Login](../assets/documentation/sonarqube/sonar_qube_user.PNG)

Now open your personal account settings.

![My account](../assets/documentation/sonarqube/sonarqube_my_account.PNG)

Generate a token in the _Security_ section.
 
![Generate token](../assets/documentation/sonarqube/sonarqube_my_account.PNG)
 
Copy the token value to the input of the preparation script and follow the instructions.
The token will be processed and integrated in the templates for future builds.

#### Prepare Jenkins slave docker images
In additon to the base Jenkins images you have the option to build additional Jenkins slave images.
To do so, just type `y` instead of typing `n` or pressing `Enter`, if you are asked, if you want to install the additional slave images. 

![Jenkins slaves](../assets/documentation/prepare-script/jenkins-slaves.PNG)

####Rundeck configuration
After the preparation script execution, you will have to configure some values in Rundeck.

Access Rundeck at http://192.168.56.31:4440/

Login with your Crowd credentials.

![Rundeck login](../assets/documentation/rundeck/rundeck-login.PNG)

Now choose the _Quickstarters_ project.

![Project selection](../assets/documentation/rundeck/project.PNG)

Open the **Job Actions** button on the right and **Import Remote Changes**

![Job actions](../assets/documentation/rundeck/remote-changes.PNG)

Click **Import**

![Import changes](../assets/documentation/rundeck/import-remote-changes.PNG)

Now you should see the imported jobs.

![Import changes](../assets/documentation/rundeck/jobs.PNG)

Choose the **verify global rundeck settings** job and execute it to verify that Rundeck has all necessary data.

![Import changes](../assets/documentation/rundeck/verify-connections.PNG)

##### Configure SCM Export plugin
If you use the Github repository, and use as is this step isn't necessary!

If you use your own repository, configure the export plugin in same way as the import plugin, except the file path template - set to `rundeck-jobs/${job.group}${job.name}.${config.format}`

### Provisioning application
####Run from OpenShift
The Provisioning application has been installed with the environment preparation script and is accessible via

https://prov-app-test.192.168.56.101.nip.io

There is no further configuration needed. 

If the application is not available, you will have to proof in OpenShift, if there have been any errors during the installation.

####Run from IDE
Open the cloned provision application in your favorite IDE

If you run the application from your IDE, you will have to provide some addional informations.

In case you want to use your local Nexus, you will have to create a `gradle.properties` file in the ods-provisioning-app project to provide the Nexus credentials, because we disabled anonymous access.

```INI
nexus_url=http://nexus-cd.192.168.99.100.nip.io
nexus_user=developer
nexus_pw=developer
```

You also have to ensure the Nexus certificate is integrated in the keystore of the JDK the IDE uses.

If you don't want to use the internal Nexus and run the application from your IDE, you will have to provide a `gradle.properties` file with the following content:

```INI
no_nexus=true
```

After startup via the IDE the application is available at http://localhost:8088/

You can login in with the Crowd admin user you set up earlier.

### Add shared images
OpenDevStack provides shared images used accross the stack - like the authproxy based on NGINX and lua for crowd

In order to install, create a new project called `shared-services`

Make the required customizations in the `ods-configuration` under **ods-core > shared-images > nginx-authproxy-crowd >  ocp-config > bc.env and secret.env**

and run `tailor update` inside `ods-core\shared-images\nginx-authproxy-crowd`:

and start the build: `oc start-build -n shared-services nginx-authproxy`.



## Try out the OpenDevStack
After you have set up your local environment it's time to test the OpenDevStack and see it working.
Open the Provisioning application in your web browser and login with your crowd credentials.

Provision your first project and have a look at your project in the Atlassian tools and OpenShift. 
