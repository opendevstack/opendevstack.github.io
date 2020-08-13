---
title: "Announcement: Version 3 of OpenDevStack"
topics:
  - General
author: clemens.utschig-utschig
---
With great pride we are announcing version [3](https://github.com/orgs/opendevstack/projects/9) of the OpenDevStack.
7+ months of work, > 1000 commits - in short, close to 100% automated test coverage, `make` based installation, a fully self contained AMI to get you started in minutes, and so many other large and small fixes, to make enterprise installation just fly.

## Major new features:

### [ODS Core](https://github.com/opendevstack/ods-core/blob/master/CHANGELOG.md#30---2020-08-11)
1. Configurable `Bitbucket` and `Openshift namespace` for ODS - to allow multiple ODS installations on the same cluster, side by side
1. Full end2end support for HTTP PROXY across all components
1. `make` based installation for the entire OpenDevStack
1. Add [automated testing](https://github.com/opendevstack/ods-quickstarters/tree/3.x/tests) to support the verification of an installation
1. [ods-devenv](https://github.com/opendevstack/ods-core/tree/3.x/ods-devenv), allowing to setup a fully self contained developer installation (which is the basis for the AMI generation)
1. A fully self contained Amazon AMI (`ODS in a Box 3.x`, `ami-0d9426211d748fc65`) - that you can just start inside your amazon account

### [ODS Jenkins Shared Library](https://github.com/opendevstack/ods-jenkins-shared-library/blob/master/CHANGELOG.md#30---2020-08-11)
1. Merge `mro orchestration pipeline` and the "original" shared library - into one `ods-jenkins-shared-library` and refactor to use common services, and also achieve better automated testing coverage
1. Sonarqube PR request support
1. Tailor can now be used to directly deploy Openshift resources
1. Massive simplification of generated jenkins pipelines, common stages, removal of `project` and `componentId`
1. Add stage to deploy to another cluster `withOpenShiftCluster` during deployment
1. Add stage to not rebuild, in case image already exists (`odsComponentStageImportOpenShiftImageOrElse`)

### [ODS Quickstarters](https://github.com/opendevstack/ods-quickstarters/blob/master/CHANGELOG.md#30---2020-08-11)
1. Add [automated tests](https://github.com/opendevstack/ods-quickstarters/tree/3.x/tests) for all quickstarters 
1. Add code coverage and unit testing steps to quickstarters
1. Use `ods jenkins shared library` accross the stack, for provisioning and build of all quickstarters
1. Quickstarters for core component contributions, namely `ods-provisioning-app` and `ods-document-generation-svc`

### [ODS Provisioning App](https://github.com/opendevstack/ods-provisioning-app/blob/master/CHANGELOG.md#120---2019-10-10)
1. Support for Azure ID as identity provider
1. Preview of modern, Angular based User interface, instead of the `thymeleaf`one
1. Better, cleaner, and consistently secured APIs across the provisioning application
1. Add pre-flight testing to ensure provisioning happens only when users, rights, etc. are available in all target systems, especially Atlassian
1. Simpler, more extensible configuration for custom quickstarters.
