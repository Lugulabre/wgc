setwd(dir = "/Users/MAEL/Documents/M2_BI/Genomique/omiques_floobits/ghozlane_achaz/wgc")

library(ggplot2)
library(memisc)

association = read.csv("association.tsv", sep = " ", header = FALSE, fill = TRUE)

association = association[-which(association$V1 == "co$"),]

stats = read.csv("stats_samtools.tsv", sep = "\t", header = FALSE)

df_fin = data.frame(association[,c(2,3)], stats)

vec_esp = summary(df_fin$V2)

sum_names = paste(association$V2, association$V3)
for (name in sum_names) {
  print(name)
}

df_pie = data.frame(names = sum_names, val = stats$V3)

df_pie_sum = tapply(df_pie$val, df_pie$names, FUN=sum)

pie(df_pie_sum, names(df_pie_sum),
    col = c("#FF0000", "#FEBFD2", "#01D758", "#FFE4C4",
            "#1E7FCB", "#E7A854", "#9683EC", "#01D758"))

sum(df_pie$val)
df_pie$val = df_pie$val/sum(df_pie$val)*100
bp = ggplot(df_pie, aes(x="", y=val, fill=names)) + geom_bar(width = 1, stat = "identity")
bp + coord_polar("y", start=0)

