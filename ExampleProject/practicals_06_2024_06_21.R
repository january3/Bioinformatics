library(phangorn)
library(seqinr)
url <- "https://january3.github.io/Bioinformatics/Practicals/practicals_02/data/hba.aln"
msa <- read.alignment(url, format="clustal")
names(msa)
msa$nb
msa$nam
msa$seq
msa$com

msa$nam <- gsub(".*(HBA_|HBA2_)", "", msa$nam)
msa$nam

msa <- as.phyDat(msa, type="AA")
dist_mat <- dist.ml(msa, model="F81")
dist_mat

mtx <- as.matrix(dist_mat)
mtx
heatmap(mtx, symm=TRUE)

nj_tree <- NJ(dist_mat)
par(mfrow=c(1, 2))

plot(nj_tree)
plot(nj_tree, type="unrooted")

# this is an error: we will not change the value of nj_tree
root(nj_tree, outgroup = c("GADMO", "POGSC"))

nj_tree <- root(nj_tree, outgroup = c("GADMO", "POGSC"))
plot(nj_tree)

make_phylo <- function(msa) {
  dist_mat <- dist.ml(msa, model = "Blosum62")
  tree <- NJ(dist_mat)
  tree <- root(tree, outgroup = c("GADMO", "POGSC"))
}

nj_tree <- make_phylo(msa)
plot(nj_tree)

boot <- bootstrap.phyDat(msa, make_phylo)
# split screen into 2 rows and 3 cols
par(mfrow=c(2,3))

for(i in 1:6) {
  plot(boot[[i]])
}

