### R School
### 6-22-2020
### Lesson 2 - Exercise results

# First I have a set up like I usually use in my scripts
##### Load packages #####
library(ComplexHeatmap)

##### Set file locations #####
# Location of RNA-Seq data file to read in
rsfile <- "G:/Shared drives/Ethylene RNA Seq experiments/Data - DO NOT EDIT FILES/DESeq2/06 logFC cutoff 0_5/03 Ethylene vs. ACC comparisons/ethylene vs ACC in Col-0 - sig results - with summary columns.csv"

# Location of ACC 449 list
mafile <- "G:/Shared drives/R School/Lesson 2 - Data frames/exercise data/ACC449.csv"

# Location to save output of script
saveloc <- "G:/Shared drives/R School/Lesson 2 - Data frames/exercise output/"

##### Set global options - heatmaps #####
# These are settings for the heatmap generated at the end
# I have several heatmaps in my RNA-Seq script, so I put all the settings at the top of the script

# Set scale for text
txtsize <- 1.5

# Set color scale
scale <- seq(-2.5, 2.5, 0.01)
# Generate color function
colfunc <- colorRampPalette(c("blue", "white", "red"))
colfunc <- circlize::colorRamp2(scale, colfunc(length(scale)))

# Generate larger legend to add in Illustrator
png(paste0(saveloc, "legend.png"), width = 100, height = 200)
draw(Legend(col_fun = colfunc,
            title = "logFC",
            legend_height = unit(40, "mm"),
            grid_width = unit(10, "mm"),
            labels_gp = gpar(cex = 1.5),
            title_gp = gpar(cex = 1.5),
            title_gap = unit(3, "mm")
            ))
dev.off()

# Labels for bottom of heatmap
anno.treat <- columnAnnotation(time = anno_mark(at = c(1:6),
                                                as.character(rep(c(1, 4, 24), 2)),
                                                labels_rot = 0,
                                                labels_gp = gpar(cex = txtsize),
                                                link_height = unit(2, "mm"),
                                                link_gp = gpar(col = "white")),
                               treatcol = c(rep("ethylene", 3), rep("ACC", 3)),
                               treat = anno_mark(at = c(2, 5),
                                                 labels = c("ethylene", "ACC"),
                                                 labels_rot = 0,
                                                 labels_gp = gpar(cex = txtsize),
                                                 link_height = unit(4, "mm"),
                                                 link_gp = gpar(col = "white")),
                               col = list(treatcol = c("ACC" = "black",
                                                       "ethylene" = "grey")),
                               simple_anno_size = unit(2, "mm"),
                               show_legend = FALSE,
                               show_annotation_name = FALSE
)




##### Part 1 - Read in data #####
rsdat <- read.csv(rsfile, row.names = 1)

head(rsdat)

malist <- read.csv(mafile, header = FALSE)

head(malist)

##### Part 2 #####
genes <- malist$V1
matches <- rsdat[rownames(rsdat) %in% genes,]
length(rownames(matches))
length(rownames(rsdat))-length(rownames(matches))

length(genes) - length(rownames(matches))

##### Part 3 #####
ordered_rsdat = matches[order(matches$allsum),]
write.csv(ordered_rsdat, outsave)

write.csv(ordered_rsdat, paste0(saveloc, "sortedmatches.csv"))

head(ordered_rsdat)

##### Part 4 #####
rsdat[which(rsdat$eth.sum != "n" | rsdat$acc.sum != "n"),]
rsdat[which(rsdat$allsum != "n.n"),]

# OR which(thing1 = 1 | thing2 = 2)
# AND which(thing1 =2 & thing2 = 2)

responseethylene <- rsdat[which(rsdat$allsum == "U.n" | rsdat$allsum == "U.D" | rsdat$allsum == "U.U")]
responseacc<- rsdat[which(rsdat$allsum == "D.U" | rsdat$allsum == "U.U" | rsdat$allsum == "n.U")]

##### Part 5 #####
rsdatht <- rsdat[, grep("logFC", colnames(rsdat))]
rsdatht <- rsdatht[, -grep("max", colnames(rsdatht))]
rsdatht <- as.matrix(rsdatht)

##### Part 6 - Heatmap #####
# This is a simplified version of the heatmap I generated for the manuscript using the ComplexHeatmaps package:
png(paste0(saveloc, "ethylene vs. ACC - results for ACC 449.png"), width = 450, height = 700)
Heatmap(as.matrix(rsdatht),
        name = "logFC",
        cluster_columns = FALSE,
        show_row_names = FALSE,
        show_row_dend = FALSE,
        col = colfunc,
        bottom_annotation = anno.treat,
        column_labels = rep("", 6),
        width = unit(4, "in")
)
dev.off()