# crap. It did not save it, grr
## (my oldschool editor saves automatically, so I don't think about it)

#### asdff asdf asdff ####

5 + 7
a <- 5 + 7
5 ** 7 # obsolete, but works
5^7 # same as 5 ** 7

blah <- myfunc(par1) {
  
  ## asdfasdf
  
  
}

## what does the following do?
5 %/% 7
5 / 7
5 %% 7

## everything is a vector!
v <- c(1, 2, 3) 
is.vector(v)
v <- TRUE
is.vector(v)
v <- 1
is.vector(v)

## vectorization, you need to 
c(1, 2, 3) * 5
c(1, 2, 3) * c(2, 5) # error message!
c(1, 2, 3) * c(1, 5, 10)
## scalar product
c(1, 2, 3) %*% c(1, 5, 10)

## to get help on operators, you need to use quotes
?"%*%"
?"%%" # what is this operator

## get random numbers and plot them
x <- rnorm(100)
y <- x + rnorm(100)
plot(x, y)

## 
cor(x, y)
cor(x, y, method="s")
cor.test(x, y)
cor.test(x, y, method = "s")
