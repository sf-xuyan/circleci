# Base Pkg
## Key steps:
### create pkg
sfdx force:package:create -n base -d 'circleci - base pkg' -t Unlocked -r 'base-app' -v DevHub -e
### create pkg version
sfdx force:package:version:create -p base -d 'base-app' -k Pa55word -w 30 -v DevHub
### installation info
Subscriber Package Version Id: 04t5j0000001ARWAA2
Package Installation URL: https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5j0000001ARWAA2
## Q&A
Q1: `sfdx force:source:pull`工作机制？
A1: 当scratch org元数据发生变化后，该cli可讲add / change同步到本地。如果在local system将拉取后到metadata删除了，再使用该cli将无法拉取metadata。