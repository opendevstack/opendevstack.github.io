# Using the opendevstack

## Create an integrated OpenDevStack project
Trigger a project creation thru the [provisioning application](https://github.com/opendevstack/ods-provisioning-app/) to get a new project, or modify an existing one.

When `openshiftproject == true`, this will also create Openshift projects, namely `<project-KEY>`-DEV and `<project-KEY>`-TEST.
A [Jenkins deployment](https://github.com/opendevstack/ods-core) will be created in the `<project-KEY>`-CD Project to allow a project full freedom of build management.

## Pull a quickstarter into your project
Open the web gui of the provisioning app `https://prov-app-test.<app-domain-of-your-openshift-cluster>`
This time, rather than `new initiative` pick `modify` and your project. Pick a matching [quickstarter](https://github.com/opendevstack/ods-project-quickstarters). If no framework fits to your needs, fall back to the 
  [be-plain-docker quickstarter](https://github.com/opendevstack/ods-project-quickstarters/blob/master/boilerplates/be-docker-plain/README.md).

# Ready to develop?

## Result after quickstarted
Now you got the template of the picked `quickstarter` in your Bitbucket project, that the [provision app](https://github.com/opendevstack/ods-provisioning-app/) created, in its own repository. Also the application created is installed with the demo code of the [boilerplate](https://github.com/opendevstack/ods-project-quickstarters/tree/master/boilerplates) in your `project`-TEST project. And lastly bitbucket is connected with webhooks to Jenkins so CI/CD is working.

## Checking in my app code
Create a branch in the repository, this is connected to the application in `<project-KEY>`-DEV project.
  Do your development here, see all changes after commited in bitbucket immediate in the `<project-KEY>`-DEV project.
  After reached your next state, merge your branch to master to see the update in `<project-KEY>`-TEST project.
 
This logic is based on the [jenkins shared library](https://github.com/opendevstack/ods-jenkins-shared-library) and can be tailored to your needs.
  
