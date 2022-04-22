# 5.4 mapply -------------------------------------------------------------------

# Vectorised lapply.
# mapply(FUN, ..., MoreArgs = NULL, SIMPLIFY = TRUE, USE.NAMES = TRUE)
rep(1, 4)
rep(4, 1)

# Examples:
mapply(rep, 1:4, 4:1)
mapply(rep, times = 1:4, x = 4:1)
mapply(rep, times = 1:4, MoreArgs = list(x = 42))
mapply(function(x, y) seq_len(x) + y,
       c(a =  1, b = 2, c = 3),
       c(A = 10, B = 0, C = -10))

# 6. Other loops ---------------------------------------------------------------

# 6.1 do.call() ----------------------------------------------------------------

ex <- mapply(rep, 1:4, 4:1)
ex

# Examples

# 1.
do.call(c, ex) 
unlist(ex)

# c(ex[[1]], ex[[2]], ex[[3]], ex[[4]])
# 
# res <- numeric()
# for(i in 1:length(przyklad)){
#   wyniki <- c(res, przyklad[[i]])
# }
# res

# 2.
do.call(sum, ex)
sum(unlist(ex))

# 3.
library(ggplot2)
subsets <- split(diamonds, diamonds$cut)

res <- lapply(podzbiory, head)
res <- do.call(rbind, res)
res <- as.data.frame(res)
res

# 6.2. replicate() -------------------------------------------------------------

# Replicates the procedure certain amounts of time.

# Population vector
pop <- rnorm(10000, 10, 1)

# Sampling (25000 repeats):
est1 <- replicate(expr = mean(sample(x = pop, size = 5)), n = 25000)

# 6.3 sweep() ------------------------------------------------------------------

# apply for operators:
data(iris)
iris2 <- iris[, -5]

iris_avgs <- apply(iris2, 2, mean)
iris_sd <- apply(iris2, 2, sd)

iris_stand <-  sweep(iris2, 2, iris_avgs, "-") 
iris_stand <- sweep(iris_stand, 2, iris_sd, "/")

summary(iris_stand)
