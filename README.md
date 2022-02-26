# Base Pkg
## Q&A
Q1: `sfdx force:source:pull`工作机制？
A1: 当scratch org元数据发生变化后，该cli可讲add / change同步到本地。如果在local system将拉取后到metadata删除了，再使用该cli将无法拉取metadata。