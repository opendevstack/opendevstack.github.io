## Using the opendevstack

# Create a integrated project
Trigger a project creation to get a project in Atlassian.
This will create Openshift projects <project-KEY>-DEV and <project-KEY>-TEST.
Jenkis will be created in the <project-KEY>-CD Project.

# Pull a quickstarter into your project
Open the web gui of the provisioning app https://prov-app-test.<app-domain-of-your-openshift-cluster>
Select here modify and your project. Pick a matching quickstarter. If nothing matches, fall back to the 
  be-plain-docker.

## Ready to develop
# Result after quickstarted
Now you got the template of the picked quickstarter in your Bitbucket project in an own repository named like you specified in the provisioning app. Also the app is installed with the demo code of the boilerplate in your TEST project. Also Bitbucket is connected with webhooks to Jenkins so CI/CD is working.

# Checking in my app code
Create a branch in the repository, this is connected to the application in <project-KEY>-DEV project.
  Do your development here, see all changes after commited in bitbucket immediate in the <project-KEY>-DEV project.
  After reached your next state, merge your branch to master to see the update in <project-KEY>-TEST project.
  
