---
title: "Announcement: Version 1.2 of OpenDevStack"
topics:
  - General
author: clemens.utschig-utschig
---
With great pride - we are announcing version [1.2](https://github.com/orgs/opendevstack/projects/8) of the OpenDevStack.
6+ months of work, > 500 commits - in providing new features, such as document generation, multi repository orchestration, and new and updated quickstarters.

## Major new features:

### [ODS Core](https://github.com/opendevstack/ods-core/blob/master/CHANGELOG.md#120---2019-10-10)
1. Register both the jenkins build shared lib as well as the new MRO library as global trusted libraries
2. Add go quickstarter SQ scanning plugin
3. Allow jenkins master to connect to self signed certificate OCP/OKD instances

### [ODS Jenkins Shared Library](https://github.com/opendevstack/ods-jenkins-shared-library/blob/master/CHANGELOG.md#120---2019-10-10)
1. Make ODS build pipeline ready for multi repo orchestration
1. Fix small pipeline issues (e.g. apostrophe in committer's name)

### [ODS Quickstarters](https://github.com/opendevstack/ods-project-quickstarters/blob/master/CHANGELOG.md#120---2019-10-10)
1. Go lang quickstarter added
1. Airflow cluster quickstarter added
1. Consistent unit test and code coverage for all quickstarters added, so the MRO can use the results
1. New Release manager quickstarter added

### [ODS Provisioning App](https://github.com/opendevstack/ods-provisioning-app/blob/master/CHANGELOG.md#120---2019-10-10)
1. Support for oauth2 instead just Atlassian Crowd
2. Service adapter framework to plug in other bugtrackers

### [ODS MRO Jenkins shared library](https://github.com/opendevstack/ods-mro-jenkins-shared-library)
1. The cornerstone of the 1.2 release - the new multirepo orchestration and document generation pipeline