---
title: "Announcement: Version 1.0 of OpenDevStack"
topics:
  - General
author: clemens.utschig-utschig
---
With great pride - we are announcing version [1.0](https://github.com/orgs/opendevstack/projects/3) of the OpenDevStack.
7+ months of work, > 500 commits, went into making the original version from [BI X](https://bix-digital.com) ready for the first major release.

## Main Features:

### [ODS Core](https://github.com/opendevstack/ods-core)
1. Provide jenkins image(s) including owasp scan dependencies on top of the official Redhat ones (registry.access.redhat.com/openshift3/jenkins-*)
1. Nexus and Sonarqube integrated setup running on OpenShift
1. Provide webhook proxy, so we don't need to search for the right commit, branch, etc.

### [ODS Jenkins Shared Library](https://github.com/opendevstack/ods-jenkins-shared-library)
1. Provide consistent way of building, testing, deploying and scanning projects - radical simplification of building
1. Auto creation of environment for a given branch if desired

### [ODS Quickstarters](https://github.com/opendevstack/ods-project-quickstarters)
1. As opposed to v.0.1 the generator images now inherit from the builder slaves, so we make sure what's generated - also works during build
1. Slaves support HTTP proxy now, and bind themselves to the ODS Nexus for artifact mgmt

### [ODS Provisioning App](https://github.com/opendevstack/ods-provisioning-app)
1. Many (many) bugfixes went in, now full support for permission sets (rather than inheriting the global jira, confluence, bitbucket roles and rights)

### [Tailor](https://github.com/opendevstack/tailor)
1. CLI on top of the OC CLI - used thruout ODS for installation, patching etc. Allows for diff against current version, and single attribute / config patching