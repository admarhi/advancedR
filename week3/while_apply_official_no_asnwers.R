#---------------------------------------------------------#
#                Advanced Programming in R                #
#          Laboratory 1: loops and if statement           #
#                 Academic year 2021/2022                 #
#             Materials prepared by:                      #
#             Piotr Ćwiakowski, Piotr Wójcik              #
#             Classes conducted by:                       #
#             Maria Kubara & Ewa Weychert                 # 
#---------------------------------------------------------# 

Sys.setenv(LANG = "en")


# 3. While loop ----------------------------------------------------------------
# Syntax:
# while( CONDITION ){ COMMAND }
# Literally: do COMMAND while CONDITION is TRUE.
# While loop, in order to be finite, has to have some fragment of code in the COMMAND section, 
# which influences the CONDITION. Otherwise we will get a infinite loop 
# (if the initial CONDITION was meet).

# Example:
# if n<10 print n and add to n one
# what will be the last printed value by while?
n <- 0
while(n <= 10) {
   print(n)
   n <- n + 1
}

# We can always rewrite the while into for:
# we assume big range to make sure that all will be conducted
n <- 0
for (n in 1:1000000){
  print(n)
  n <- n + 1
  # the break conditional
  if (n >= 10){
    break
  }
}

# sometimes it is difficult to anticipate how many iteration we will have
# then we use while 
# sometimes while is more readable than for loop
# less code more elegant and smarter
# while is easier to interpret
# in regular loop condition is not presented at the beggining and we need to have defined range of iterations


# But the drawbacks are:
# - more code
# - less elegant
# - more difficult to intepret

# Example if infinite loop:
# infinitfe loop will not stop himself. We need to press esc
# the condition in this loop is always true 
while(TRUE) {print("click ESC")}

mean(1:10)

# mean(1:10 --> click ESC

# 4. Repeat loop ---------------------------------------------------------------

# infinite loop

repeat{
  print('Infinite loop, press ESC')
}

# 5. Family of apply functions  ------------------------------------------------
# 
# In statistical programming, loops are usually over elements of certain objects: 
# matrixes or data.frames. To iterate over rows, columns or elements of object we 
# can use apply function. They are faster and offer shorter syntax (albeit less 
# intuitive).

# Apply functions forms family of functions, starting from basic apply to more
# specialised. The most prevalent functions are:

# 1. apply
# 2. lapply
# 3. sapply
# This one for more eager students in the materials: 
# 4. vapply
# 5. tapply
# 6. mapply


# 5.1. apply -------------------------------------------------------------------
# Loop which applies a function to rows or columns of a table.

# Usage:
# apply(X, MARGIN, FUN, ...)

# X - object with margins - rows and columns
# margin - types of margin - rows (1) or columns (2)
# FUN - function to be performed on each element of given dimention (margin)
# ... - aditional arguments of function

# Example:
table <- cbind(c(1:8),c(10:17),c(15:8)) # columnbind, also r bind
table

apply(table, 1, mean) # mean of each row
apply(table, 1, mean, na.rm = T) # mean of each row
apply(table, 1, function(x) mean(x, na.rm = T)) # mean of each row
apply(table, 2, max)  # max of each column

# Very often in apply is implemented anonymous function - written 'on the run'.
table2 <- apply(table, 1, function(x) c(mean(x), median(x))) 

# Print results
table2

# Let's examine a function which returns a vector:
apply(table, 1, range)




# 5.2. lapply function ---------------------------------------------------------
# lapply() function works with lists, applying to each element a user-defined or
# built-in function. The return object is a list

# Usage:
# lapply(list, FUN,...)

# Arguments:
# list - an object which is list (so data.frame can be used!!)
#  ... additional parameters of a function

# First let's understand what is a list:

# List creation:
list1 <- list()

# Adding fields (od different types)
list1[[1]] <- 1:100
list1[['iris']] <- iris
list1[['letter']] <- 'P'

# indexing:
list1[['iris']]
list1[[2]]
list1[2]
list1$iris

# List are a quite common objects in R enviroment:
model <- lm(Sepal.Length ~ Sepal.Width, data = iris)
summary(lm(Sepal.Length ~ Sepal.Width, data = iris))
class(model)
is.list(model)
names(model)

# Indexing list of class lm
model[['coefficients']]
model[['residuals']]

model$fitted.values

# Data.frame is also a list...
is.data.frame(iris)
is.list(iris)

# Now let's go back to lapply.

# Let's define a list:
L <- list(a = c(1, 2), 
          b = c(3, 5, 7)
)
# Apply sinus function to list elements:
L2 <- lapply(L, sin)

# Investigating result
L2

# Another example with anonymuos function:
L3 <- lapply(L, function(x) {x^2}) 
L3

# And even with function return one value... 
L4 <- lapply(L, mean)
#... result is still a list 
L4 

# Here a magical function:
ewa<-unlist(L4)

class(ewa)
# In the end let's look at the function with additional arguments:
runif(n = 4, min = 0, max = 5)

# What is the structure of the object returned by following procedure:

lapply(1:4, runif, min = 0, max = 10) 

for (i in 1:4) {
  print(runif(n = i, min = 0, max = 5))
}


# 5.3. sapply ------------------------------------------------------------------

# Sapply is simplified lapply function. Function returns:
# 1. Vector, if all elements of the result are single values
# 2. Matrix if all elements of the result have the number of values.
# 3. List otherwise.

# Objects for examples:
L0 <- list(a = 1, b = 3)
L1 <- list(a = c(1, 2), b = c(5, 6))
L2 <- list(a = c(1, 2, 3), b = c(5, 6))

L0
L1
L2

# Examples
W0 <- sapply(L0, function(x) { x^3 }) # vector 
W1 <- sapply(L1, function(x) { x^3 }) # matrix 
W2 <- sapply(L2, function(x) { x^3 }) # list

# Let's analize results:
is.vector(W0);W0
is.matrix(W1);W1
is.list(W2);W2

# If we want ordinary lapply() we can set simplify = F 
W <- sapply(L, function(x){x^3}, simplify = F); W # list
W1 <- sapply(L1, function(x){x^3}, simplify = F); W1 # list
W2 <- sapply(L2, function(x){x^3}, simplify = F); W2 # list



# Exercises --------------------------------------------------------------------

# 3. Based on iris dataset find average, median, max i min for each column. 
# Present results in one matrix.
# https://www.magesblog.com/post/2012-01-28-say-it-in-r-with-by-apply-and-friends/

head(iris)
apply(iris[,-ncol(iris)], 2, function(x) c(mean(x, na.rm = TRUE),
                                           max(x, na.rm = TRUE),
                                           min(x, na.rm = TRUE)))




# 4. Use lapply function to log every numeric variable in iris dataset. Save the 
# result (transformed and non-transformed variables) in:
# lapply(list, FUN,...)

# a. list
lapply(iris[,-ncol(iris)], log)

# b. data.frame
dat <- lapply(iris[,-ncol(iris)], log)
as.data.frame(dat)


# 5. Used split() and interaction function to split diamonds dataset with respect to
# two categorical variables: color and cut. Then:
library(ggplot2)
data(diamonds)
head(diamonds)

data.list <- split(diamonds, interaction(diamonds$cut, diamonds$color))


# a. for each element perform a regression: price ~ carat. Save the results in the list
amh <- lapply(data.list, function(x) lm(price ~ carat, data = x))
amh
# b. for each model generate summary and save result in another lists.
amhSummary <- summary(amh)
amhSummary

# c. for each model generate histogram of residuals, or any other graph.

# d. extract coefficients from each model and save it in one big list.

# 6. Generate a list of 100 vectors: c(1), c(1,2), c(1,2,3), ... , c(1,...,100)



