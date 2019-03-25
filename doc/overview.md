# Using OpenDevStack

## Create an integrated OpenDevStack project
Trigger project creation thru the [provisioning application](https://github.com/opendevstack/ods-provisioning-app/) to get a new project.

When `openshiftproject == true`, this will also create OpenShift projects, namely `<project-KEY>-dev` and `<project-KEY>-test`.
A [Jenkins deployment](https://github.com/opendevstack/ods-core) will be created in the `<project-KEY>-cd` project to allow each project full freedom of build management.

## Pull a quickstarter into your project
Open the web GUI of the provisioning app `https://prov-app-test.<app-domain-of-your-openshift-cluster>`.
This time, rather than `new initiative`, pick `modify` and select your project. Pick a matching [quickstarter](https://github.com/opendevstack/ods-project-quickstarters). If no framework fits to your needs, choose the 
  [be-plain-docker quickstarter](https://github.com/opendevstack/ods-project-quickstarters/blob/master/boilerplates/be-docker-plain/README.md).

# Ready to develop?

## Result after quickstarted
Now you got the [boilerplate](https://github.com/opendevstack/ods-project-quickstarters/tree/master/boilerplates) of the picked quickstarter in your BitBucket project in its own repository, which the [provisioning app](https://github.com/opendevstack/ods-provisioning-app/) created. Also, CI/CD is already working - you can verify this as the boilerplate application runs in the `<project-KEY>-test` project. This was deployed through a Jenkins pipeline which is triggered via webhooks from BitBucket.

## Checking in my app code
Create a branch in the repository - once pushed this will deploy your application to the `<project-KEY>-dev` project. After merging your branch to `master`, the update is avilable in the `<project-KEY>-test` project.
 
The branch-to-environment mapping is defined in the `Jenkinsfile`, used by the [jenkins shared library](https://github.com/opendevstack/ods-jenkins-shared-library), and can be tailored to your needs.
  
