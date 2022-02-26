# Pkg1 Pkg
## Basic Info
1. Permission Set: pkg1_pset
## Key steps:
### install base pkg
sfdx force:package:install -w 30 -b 30 -p 04t5j0000001ARWAA2 -k Pa55word -r -u pkg1
### assign permission set
sfdx force:user:permset:assign -n base_pset -u pkg1
### create pkg
sfdx force:package:create -n my_pkg1 -d 'circleci - pkg1 pkg' -t Unlocked -r 'pkg1-app' -v DevHub -e
### create pkg version
sfdx force:package:version:create -p my_pkg1 -d pkg1-app -k Pa55word -w 30 -v DevHub
### installation info
Subscriber Package Version Id: 04t5j0000001ARqAAM
Package Installation URL: https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5j0000001ARqAAM
## Q&A
Q1. Permission Set管理策略？
A1. base打包时，建议不创建permission set，当base安装到对应子包时，为子包构建permission set可以选择base包中的metadata。例如：base中有BaseHelper.cls，它在pkg1中会被pkg1_MyClass.cls引用，因此建议base不构建permission set，而在pkg1中去构建BaseHelper.cls和pkg1_MyClass.cls的权限级。
Q2. 如何打包含依赖的pkg？
A2. 在scratch org线安装base pkg，然后构建pkg1，随后在sfdx-project.json中需要配置base pkg的packageAliases info和依赖关系，才能打包pkg1.