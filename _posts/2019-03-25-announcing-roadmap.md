---
title: "2019 roadmap and other ODS news"
topics:
  - General
author: clemens.utschig-utschig
---
We have been pretty heads down for the last couple of months, in getting new stuff to fly for Version [1.1](https://github.com/orgs/opendevstack/projects/4), next to maintaing the [1.0.x train](https://github.com/orgs/opendevstack/projects/7).

*Version 1.1* focuses on a few important topics:
1. [Data Science & ML quickstarter](https://github.com/opendevstack/ods-project-quickstarters/tree/master/boilerplates/ds-ml-service)
1. finally writing documentation (which we are pretty much done, at least for cut one :)) - there is now a README for each major component, and repo
1. Adding some pretty useful features to [provision app](https://github.com/opendevstack/ods-provisioning-app) around project templates, and refactoring of the HTTP call mess we had with 0.1 / 1.0.x
1. Providing a new release manager quickstarter to move an entire namespace & application into a new namespace - e.g. when you want to move from dev to test. (and automatically generate you documentation around your application)

*Version 2.0* will focus on one big topic:
1. Rework quickstarters and remove rundeck from the ODS mix, a lot of complexity will vanish and 
morphe into std. Jenkins jobs.
