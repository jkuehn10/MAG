### Purpose: MARS shotgun metagenomic MAG
### Created: 2024-06-04

#source("/Users/rootqz/R/QZ_functions.R")
#options(stringsAsFactors = FALSE)

#setwd("/Users/rootqz/Desktop/ReyLab/project/MARS/")

# load sample meta data
#meta_wgs <- fread("data/meta_wgs.csv") %>% as.data.frame()
setwd("/Users/kuehn4/Downloads/")
# load MAG info
library(readr)
library(tidyverse)

mag_checkm <- read_tsv("result/MAG_checkm_summary.tsv")
mag_stats <- read_tsv("result/MAG_checkm_bin_stats.tsv")

# merge MAG checkm summary and stats
mag_meta <- mag_checkm %>% left_join(mag_stats, by = "Bin_ID")


## load dRep clusters output file
drep_out_cdb <- read_csv("result/MAG_drep_out/data_tables/Cdb.csv") %>%
    separate(genome, ".f", into=c("Bin_ID", NA))
drep_out_info <- read_csv("result/MAG_drep_out/data_tables/genomeInformation.csv") %>%
    separate(genome, ".f", into=c("Bin_ID", NA))
drep_out <- drep_out_cdb %>%
    left_join(drep_out_info %>% select(Bin_ID, centrality), by = "Bin_ID")

# filter MAG with Completeness > 90 and Contamination < 5, merge MAG with dRep cluster info
mag_drep <- mag_meta %>%
    filter(Completeness > 90, Contamination < 5) %>%
    select(Bin_ID, Marker_lineage, Completeness, Contamination, Strain_heterogeneity, 
           GC, `Genome size`, `# contigs`, `Longest contig`, `N50 (contigs)`, `# predicted genes`) %>%
    left_join(drep_out %>% select(Bin_ID, primary_cluster, secondary_cluster, centrality), by = "Bin_ID")

# score MAG using dRep method
# A*Completeness - B*Contamination + C*(Contamination * (strain_heterogeneity/100)) + D*log(N50) + E*log(size) + F*(centrality - S_ani)
# default: A=1, B=5, C=1, D=0.5, E=0, F=1

mag_drep_score <- mag_drep %>%
    mutate(score = 1*Completeness-5*Contamination+1*(Contamination*(Strain_heterogeneity/100))+0.5*log(`N50 (contigs)`)+1*(centrality-0.99))

mag_drep_winner <- mag_drep_score %>%
    group_by(secondary_cluster) %>%
    filter(score == max(score))

write_tsv(mag_drep_score, file = "result/MAG_drep_all.tsv")
write_tsv(mag_drep_winner, file = "result/MAG_drep_winner.tsv")



