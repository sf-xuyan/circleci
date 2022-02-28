<<<<<<< HEAD
# Base Pkg
## Key steps:
### create pkg
sfdx force:package:create -n base -d 'circleci - base pkg' -t Unlocked -r 'base-app' -v DevHub -e
### create pkg version
sfdx force:package:version:create -p base -d 'base-app' -k Pa55word -w 30 -v DevHub --branch base
### installation info
<!-- v1.0 -->
Subscriber Package Version Id: 04t5j0000001ARWAA2
Package Installation URL: https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5j0000001ARWAA2
<!-- v2.0 -->
Subscriber Package Version Id: 04t5j0000001ARlAAM
Package Installation URL: https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5j0000001ARlAAM
## Q&A
Q1: `sfdx force:source:pull`工作机制？
A1: 当scratch org元数据发生变化后，该cli可讲add / change同步到本地。如果在local system将拉取后到metadata删除了，再使用该cli将无法拉取metadata。
=======
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
sfdx force:package:version:create -p my_pkg1 -d pkg1-app -k Pa55word -w 30 --codecoverage -v DevHub
### promote your pkg version
sfdx force:package:version:promote -p my_pkg1@0.1.0-3-pkg1 -n -v DevHub
### installation info
<!-- v1.0 -->
Subscriber Package Version Id: 04t5j0000001ARqAAM
Package Installation URL: https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5j0000001ARqAAM
<!-- v2.0 add test class -->
Subscriber Package Version Id: 04t5j0000001ARvAAM
Package Installation URL: https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5j0000001ARvAAM
<!-- v3.0 specify codecoverage for promotion -->
Subscriber Package Version Id: 04t5j0000001AS0AAM
Package Installation URL: https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5j0000001AS0AAM
## Q&A
Q1. Permission Set管理策略？
A1. base打包时，建议不创建permission set，当base安装到对应子包时，为子包构建permission set可以选择base包中的metadata。例如：base中有BaseHelper.cls，它在pkg1中会被pkg1_MyClass.cls引用，因此建议base不构建permission set，而在pkg1中去构建BaseHelper.cls和pkg1_MyClass.cls的权限级。
Q2. 如何打包含依赖的pkg？
A2. 在scratch org线安装base pkg，然后构建pkg1，随后在sfdx-project.json中需要配置base pkg的packageAliases info和依赖关系，才能打包pkg1.
Q3. promote for production - ERROR running force:package:version:promote:  Code coverage has not been run for this version.  Code coverage must be run during version creation and meet the minimum coverage requirement to promote the version.
A3. Ref: https://trailhead.salesforce.com/en/trailblazer-community/feed/0D54S00000A8fP8SAJ
Q4. 包依赖安装？
A4. 默认的，pkg1依赖base pkg，在org1安装pkg1前必须先安装base pkg。但是可以参考https://blog.texei.com/automatically-install-second-generation-packages-dependencies-with-a-custom-sfdx-plugin-36ec83130457解决此问题
依赖包安装指南：
`sfdx plugins:install texei-sfdx-plugin`
1st -> 会自动从sfdx-project.json中找依赖包进行安装，无需手动指定pkgVerId
`sfdx texei:package:dependencies:install -u org2 -v DevHub -k '1:Pa55word'`
then
`sfdx force:package:install -w 30 -b 30 -p 04t5j0000001AS0AAM -k Pa55word -r -u org2`
>>>>>>> pkg1
