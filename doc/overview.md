---
layout: documentation
---

# Using OpenDevStack - a small quickstart

## What is OpenDevStack
When we started with [Redhat's OpenShift](https://www.openshift.com/) we were blown away by the 100s of possibilities to use it, while there was not anything along "This is how you make it work for your org".

Its catalog provides items for almost everything - yet what we wanted is to enable people to quickly introduce
Continous delivery and standardized technology archetypes. We call this lean, empowered governance.

So what does OpenDevStack now provide?
1. A set of images to get the CI infrastructure running, called [ods-core](https://github.com/opendevstack/ods-core). It also contains [ansible runbooks](https://github.com/opendevstack/ods-core/tree/master/infrastructure-setup) to get the atlassian suite going.
1. A shared [jenkins library](https://github.com/opendevstack/ods-jenkins-shared-library) that harmonizes the way you build, test, govern and deploy.
1. A set of [technology quickstarters](https://github.com/opendevstack/ods-project-quickstarters) that already provide the complete CI/CD integration, w/o anything to worry about for the engineer
1. A small [provision application](https://github.com/opendevstack/ods-provisioning-app) that gives you one place to start, no matter if you want to start a new initiative, or enhance and existing one.

## Create an integrated OpenDevStack project
Trigger project creation thru the [provisioning application](https://github.com/opendevstack/ods-provisioning-app/) to get a new project. The web GUI of the provisioning app is located at `https://prov-app-test.<app-domain-of-your-openshift-cluster>`.

When `openshiftproject == true`, this will also create OpenShift projects, namely `<project-KEY>-dev` and `<project-KEY>-test`.
A [Jenkins deployment](https://github.com/opendevstack/ods-core) will be created in the `<project-KEY>-cd` project to allow each project full freedom of build management. This deployment is based on [common jenkins images](https://github.com/opendevstack/ods-core) from the `CD` namespace.

## Pull a quickstarter into your project
Open the web GUI of the provisioning app `https://prov-app-test.<app-domain-of-your-openshift-cluster>`.
This time, rather than `new initiative`, pick `modify` and select your project. Pick a matching [quickstarter](https://github.com/opendevstack/ods-project-quickstarters). If no framework fits to your needs, choose the 
  [be-plain-docker quickstarter](https://github.com/opendevstack/ods-project-quickstarters/blob/master/boilerplates/be-docker-plain/README.md).

# Ready to develop?

## Result after quickstarted
Now you got the [boilerplate](https://github.com/opendevstack/ods-project-quickstarters/tree/master/boilerplates) of the picked quickstarter in your BitBucket project in its own repository, which the [provisioning app](https://github.com/opendevstack/ods-provisioning-app/) created. Also, CI/CD is already working - you can verify this as the boilerplate application runs in the `<project-KEY>-test` project. This was deployed through a [Jenkins pipeline](https://github.com/opendevstack/ods-jenkins-shared-library), which is triggered via [webhooks](https://github.com/opendevstack/ods-core/tree/master/jenkins/webhook-proxy) from BitBucket.

## Checking in my app code
Create a branch in the newly created repository - once pushed this will deploy your application to the `<project-KEY>-dev` project. After merging your branch to `master`, the update is avilable in the `<project-KEY>-test` project.
 
The branch-to-environment mapping is defined in the `Jenkinsfile`, used by the [jenkins shared library](https://github.com/opendevstack/ods-jenkins-shared-library), and can be tailored to your needs.
  