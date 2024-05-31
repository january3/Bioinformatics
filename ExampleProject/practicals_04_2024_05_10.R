a <- 10

# this is a comment. It will not do anything.
10 * 2
10 - 2
10^2 
10**2

# whenetver we use a, it is as if we have used "10"
a * 2
a - 2
a^2

# variables can have character values:
a <- "sensei"
a * 2

# no implicit conversion from char to value
a <- "2"
a * 2

a <- 55

# where are we?
getwd()

# vectors!
a <- 10
b <- c(109, 42, 23, 1111)

a * 2
b * 2
c <- b * 2
b * c

b[1]

bone <- b[1]
sel <- c(1, 2)
bone_and_two <- b[sel]

# don't forget to assign the result of a function
bsum <- sum(b)
