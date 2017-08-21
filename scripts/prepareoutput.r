#!/usr/bin/env Rscript
options(stringAsfactors = FALSE, useFancyQuotes = FALSE)

# Taking the command line arguments
args <- commandArgs(trailingOnly = TRUE)


library(jsonlite)
inputMatrix<-""
inputJson<-""
outputPeakTable<-""
outputVariables<-""
outputMetaData<-""
for(arg in args)
{
  argCase<-strsplit(x = arg,split = "=")[[1]][1]
  value<-strsplit(x = arg,split = "=")[[1]][2]
  
  if(argCase=="inputmatrix")
  {
    inputCamera=as.character(value)
  }
  if(argCase=="inputjson")
  {
    inputJson=as.character(value)
  }
  
  if(argCase=="outputPeakTable")
  {
    outputPeakTable=as.character(value)
  }
  if(argCase=="outputVariables")
  {
    outputVariables=as.character(value)
  }  
  if(argCase=="outputMetaData")
  {
    outputMetaData=as.character(value)
  }
  
  
}



dataMatrix<-read.table(inputMatrix,header = T,stringsAsFactors = F,sep = "\t")
jsonFile<-fromJSON(inputJson, simplifyVector = FALSE)

peakData<-data.frame(matrix(NA,nrow = ncol(dataMatrix),ncol = nrow(dataMatrix)+1))
peakData[1,1]<-"dataMatrix"
peakData[-c(1),1]<-paste("variable_",seq(1,length(peakData[-c(1),1])),sep="")
peakData[1,-c(1)]<-dataMatrix[,1]
peakData[-c(1),-c(1)]<-t(dataMatrix)[-c(1),]
names(peakData)<-peakData[1,]
peakData<-peakData[-c(1),]


numberOfFactors<-length(jsonFile$studies[[1]]$factors)
factorNames<-c()
for(i in seq(1,numberOfFactors))
{
  factorNames<-c(factorNames,jsonFile$studies[[1]]$factors[[i]]$factorType$annotationValue)
}
MetdaData<-
  data.frame(matrix(NA,nrow =length(pe$studies[[1]]$materials$samples),ncol =  numberOfFactors+1))
names(MetdaData)<-c("sampleMetadata",factorNames)
for(i in seq(1,length(pe$studies[[1]]$materials$samples)))
{
  MetdaData[i,1]<-pe$studies[[1]]$materials$samples[[i]]$name
  for(j in seq(1,numberOfFactors))
  {
    MetdaData[i,factorNames[j]]<-pe$studies[[1]]$materials$samples[[i]]$factorValues[[j]]$value$annotationValue
  }
  
}
peakData<-peakData[,c("dataMatrix",names(peakData)[-c(1)][match(MetdaData[,1],names(peakData)[-c(1)])])]
variableInformation<-data.frame(matrix(nrow = nrow(peakData),ncol = 2))
names(variableInformation)<-c("variableMetadata","example")
variableInformation[,1]<-peakData[,1]

write.table(x = peakData,file = outputPeakTable,
            row.names = F,quote = F,sep = "\t")
write.table(x = variableInformation,file = outputVariables,
            row.names = F,quote = F,sep = "\t")

write.table(x = MetdaData,file = outputMetaData,
            row.names = F,quote = F,sep = "\t")



