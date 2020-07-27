### A Harkey
### 7-27-2020
### limma example

setwd("G:/Shared drives/R School/limma/example/")

##### Packages #####
require(GEOquery)
require(plyr)
# require(Biobase)
require(limma)

##### exprsData #####
# Pull the expression values from GEO for one sample
cont1 <- Table(getGEO("GSM2236320"))[,1:2]
# Give the expression value column a unique identifier for that sample
# (For when they are combined into one dataframe)
colnames(cont1) <- c("ProbeID", "cont1")

head(cont1)

# Repeat for other samples
cont2 <- Table(getGEO("GSM2236336"))[,1:2]
colnames(cont2) <- c("ProbeID", "cont2")
cont3 <- Table(getGEO("GSM2236352"))[,1:2]
colnames(cont3) <- c("ProbeID", "cont3")

ACC1 <- Table(getGEO("GSM2236328"))[,1:2]
colnames(ACC1) <- c("ProbeID", "ACC1")
ACC2 <- Table(getGEO("GSM2236344"))[,1:2]
colnames(ACC2) <- c("ProbeID", "ACC2")
ACC3 <- Table(getGEO("GSM2236360"))[,1:2]
colnames(ACC3) <- c("ProbeID", "ACC3")

# Combine all samples into one dataframe
exprs <- join_all(list(cont1, cont2, cont3,
                            ACC1, ACC2, ACC3),
                       by = "ProbeID", type = "full")

head(exprs)

# Make ProbeID row names
rownames(exprs) <- exprs$ProbeID
exprs <- exprs[,-1]

head(exprs)

rm(cont1, cont2, cont3, ACC1, ACC2, ACC3)

##### fData #####
# From GEO
# Attempt to download fData
fData <- Table(getGEO("GPL198"))

head(fData[,c("ID", "AGI")])

# Count number of blank AGI entries
length(which(fData$AGI == ""))

# From downloaded file
# Read locus ID file
AffyfData <- read.csv("input/downloads/AffyfData.csv", header = TRUE, as.is = TRUE)

head(AffyfData)

length(which(AffyfData$locus == ""))

# Get rid of is_control column
AffyfData <- AffyfData[,-2]

# Make ProbeSet row names
rownames(AffyfData) <- AffyfData$ProbeSet
AffyfData <- AffyfData[,-1]

# Make annotated fData
labelDescription <- colnames(AffyfData)
annotfData <- new("AnnotatedDataFrame",
                       data = AffyfData,
                       varMetadata = data.frame(labelDescription, colnames(AffyfData)))

rm(fData, AffyfData, labelDescription)

##### pData #####
# Create data frame
pData <- data.frame(matrix(NA, nrow=6, ncol=2))

rownames(pData) <- colnames(exprs)
colnames(pData) <- c("Treatment", "Replicate")

pData$Treatment <- c(rep("control", 3), rep("treated", 3))
pData$Replicate <- c(1, 2, 3, 1, 2, 3)

pData

# Create annotated data frame
labelDescription <- colnames(pData)
annotpData <- new("AnnotatedDataFrame",
                       data = pData,
                       varMetadata = data.frame(labelDescription, colnames(pData)))

rm(pData, labelDescription)

##### Build eSet #####
# Create eData
eData <- new("MIAME",
             name = "Alexandria Harkey",
             lab = "Gloria Muday at Wake Forest University",
             contact = "muday@wfu.edu / afharkey@gmail.com",
             title = "Meta-analysis of root responses to ethylene or ACC under different light conditions"
)

eSet <- new("ExpressionSet",
                 exprs = exprs,
                 phenoData = annotpData,
                 experimentData=eData,
                 featureData=annotfData)

rm(annotfData, annotpData, eData, exprs)


##### Save & read eSet #####
save(eSet, file="eSet_ACCmicroarray4hr.RData")

load("eSet_ACCmicroarray4hr.RData")
head(eSet)
