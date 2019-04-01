---
title: "ODS 1.0.2 released"
topics:
  - Releases
author: clemens.utschig-utschig
---
On the `1.0.x train` we officially released version [1.0.2](https://github.com/orgs/opendevstack/projects/7)) which contains a small set of painful bugs we discovered.

## Main Fixes:

### [ODS Core](https://github.com/opendevstack/ods-core/blob/v1.0.2/CHANGELOG.md)
- failures due to dependency changes (e.g. for NGINX)

### [ODS Jenkins Shared Library](https://github.com/opendevstack/ods-jenkins-shared-library/blob/v1.0.2/CHANGELOG.md)
- addition of image labels for `author`, `commit`, `branch`, `builder` to allow for better bottom up tracebility, as we run a binary docker build

### [ODS Quickstarters](https://github.com/opendevstack/ods-project-quickstarters/blob/v1.0.2/CHANGELOG.md)
- failures due to dependency updates (e.g. for angular and spring boot) and python slave's PIP now allows for self signed certificates of `NEXUS`

### [ODS Provisioning App](https://github.com/opendevstack/ods-provisioning-app/blob/v1.0.2/CHANGELOG.md)
- suppport for people that rename `crowd sso cookie` to run multiple atlassian environments in the same subdomain, and several small rights/roles fixes.