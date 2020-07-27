### A Harkey
### 6-26-2020
### Summarize RNA-Seq DE Genes

##### Set up #####
source("R/Rfunctions/RNASeqResults.R")

hormone <- read.csv("G:/Shared drives/R School/Lesson 3 - Functions, loops, ifelse/data/ethylene vs ACC in Col-0 - sig results.csv",
                row.names = 1)
head(hormone)

lfccut <- 0.5
pcut <- 0.05

##### Old version with loops: #####
hormone$eth.max.logFC <- NA
hormone$eth.min.pval <- NA
hormone$acc.max.logFC <- NA
hormone$acc.min.pval <- NA
hormone$eth.sum <- NA
hormone$acc.sum <- NA

for (i in 1:nrow(hormone))
{
  hormone$eth.max.logFC[i] <- maxabs(hormone[i, c("eth.01.logFC", "eth.04.logFC", "eth.24.logFC")])
  hormone$eth.min.pval[i] <- min(hormone[i, c("eth.01.padj", "eth.04.padj", "eth.24.padj")])
  hormone$acc.max.logFC[i] <- maxabs(hormone[i, c("acc.01.logFC", "acc.04.logFC", "acc.24.logFC")])
  hormone$acc.min.pval[i] <- min(hormone[i, c("acc.01.padj", "acc.04.padj", "acc.24.padj")])

  hormone$eth.sum[i] <- upordown(hormone$eth.min.pval[i],
                                 hormone$eth.max.logFC[i],
                                 pcut = pcut,
                                 lfccut= lfccut)

  hormone$acc.sum[i] <- upordown(hormone$acc.min.pval[i],
                                 hormone$acc.max.logFC[i],
                                 pcut = pcut,
                                 lfccut= lfccut)
}


##### New version with apply functions: #####
hormone$eth.max.logFC <- apply(hormone[,grep("eth.[0,2][1,4].logFC", colnames(hormone))],  1, maxabs)
hormone$eth.min.pval <- apply(hormone[,grep("eth.[0,2][1,4].padj", colnames(hormone))], 1, min)
hormone$acc.max.logFC <- apply(hormone[,grep("acc.[0,2][1,4].logFC", colnames(hormone))],  1, maxabs)
hormone$acc.min.pval <- apply(hormone[,grep("acc.[0,2][1,4].padj", colnames(hormone))], 1, min)

hormone$eth.sum <- mapply(upordown, hormone$eth.min.pval, hormone$eth.max.logFC)
hormone$acc.sum <- mapply(upordown, hormone$acc.min.pval, hormone$acc.max.logFC)
