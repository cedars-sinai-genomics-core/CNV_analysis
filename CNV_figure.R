library("ggplot2")

mydata_temp <- read.delim("./bed_files/sample27.manta.del_dup.final.bed",header = TRUE,sep="\t")
mydata1 <- mydata_temp[grep(paste(c("random", "chrUn", "chrM"),collapse="|"),mydata_temp$X.Chr, invert=TRUE),]
colnames(mydata1)[1:4] <- c("chromosome", "start", "end", "CNV_type")
colnames(mydata1)[7] <- "size"
mydata1$Samples <- c(rep("Sample27", dim(mydata1)[1]))

mydata_temp <- read.delim("./bed_files/sample6.manta.del_dup.final.bed",header = TRUE,sep="\t")
mydata2 <- mydata_temp[grep(paste(c("random", "chrUn", "chrM"),collapse="|"),mydata_temp$X.Chr, invert=TRUE),]
colnames(mydata2)[1:4] <- c("chromosome", "start", "end", "CNV_type")
colnames(mydata2)[7] <- "size"
mydata2$Samples <- c(rep("Sample6", dim(mydata2)[1]))

mydata_temp <- read.delim("./bed_files/sample30.manta.del_dup.final.bed",header = TRUE,sep="\t")
mydata3 <- mydata_temp[grep(paste(c("random", "chrUn", "chrM"),collapse="|"),mydata_temp$X.Chr, invert=TRUE),]
colnames(mydata3)[1:4] <- c("chromosome", "start", "end", "CNV_type")
colnames(mydata3)[7] <- "size"
mydata3$Samples <- c(rep("Sample30", dim(mydata3)[1]))

mydata_temp <- read.delim("./bed_files/sample2.manta.del_dup.final.bed",header = TRUE,sep="\t")
head(mydata_temp)
mydata4 <- mydata_temp[grep(paste(c("random", "chrUn", "chrM"),collapse="|"),mydata_temp$X.Chr, invert=TRUE),]
colnames(mydata4)[1:4] <- c("chromosome", "start", "end", "CNV_type")
colnames(mydata4)[7] <- "size"
mydata4$Samples <- c(rep("Sample2", dim(mydata4)[1]))

mydata <- rbind(mydata1, mydata2, mydata3, mydata4) #1394

#mydata$size <- mydata$end-mydata$start
mydata$size_modified <- mydata$size
mydata$size_modified[mydata$size_modified < 10000] = 10000

mydata$End_modified <- mydata$start + mydata$size_modified
mydata$New_start = mydata$start/1000000
mydata$New_end = mydata$End_modified/1000000

mydata$chromosome <- factor(mydata$chromosome, levels = c("chr1","chr2",  "chr3",  "chr4","chr5",  "chr6",  "chr7",  "chr8",  "chr9", "chr10", "chr11", "chr12", "chr13", "chr14", "chr15" ,"chr16", "chr17", "chr18" ,"chr19","chrX",  "chrY"))

pdf("./CNVs_per_chr_Mb_Manta_by_sample.pdf",14,20)
ggplot(mydata_1kb, aes(x=New_start, y=Samples)) + #geom_point() +
  geom_segment(aes(xend=New_end, yend=Samples, colour=CNV_type)) +  #
  geom_segment(aes(x=New_start, y=Samples, xend=New_end, yend=Samples, size=15, colour=CNV_type)) +  #, colour=CNV_type
  #geom_hline(yintercept=2, linetype=2) +
  facet_wrap(~ chromosome, scales = "free", ncol=2) +
  xlab("Position (Mb)") +
  ylab("Chromosome") +
  scale_x_continuous(breaks = round(seq(0, max(mydata_1kb$New_end), by = 10),0)) + 
  #scale_x_continuous(limits = c(0,200)) +
  #scale_size_continuous(range = c(4:22000001, 22432001:22467000))+
  #theme_bw() + 
  #theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), axis.line = element_line(colour = "black"))
  theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), axis.line = element_line(colour = "black"))
dev.off()
