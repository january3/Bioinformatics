# create two random groups
group1 <- rnorm(100)
group2 <- 1 + rnorm(100)
group1
hist(group1)
plot(group1, group2)
cor.test(group1, group2)
group3 <- group1 + rnorm(100)
cor.test(group1, group3)
