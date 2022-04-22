#---------------------------------------------------------#
#                 Advanced Programming in R               #
#                 2. Functional programming               #
#                  Academic year 2019/2020                #
#               Piotr Ćwiakowski, Piotr Wójcik            #
#---------------------------------------------------------# 

Sys.setenv(LANG = "en")

### 1. Introduction ------------------------------------------------------------

# Functions are very useful tool in programming. They help to:
# * organise your code, (by clustering repeating parts of code in blocks, 
#   distinguish parameters from algorithm, etc.)
# * DRY (Don't repeat yourself)
# * simplify it (by shortening the main source file and export given block 
#   of code to designated section or even another file)
# * make it easier to interpret (function can have names which should tell the 
#   developer what they do)

# Basic syntax:

# name_of_function <- function(arguments) {
#   >> do the math here <<
# return(result_of_doing_math_back_there)
# }


value1 <- function(n) {
  return(n)
}

# If we skip the "return" part, function will return the 
# last value from the calculations or nothing. See Examples:

value1 <- function(n) {
  n
  n*2
}

value1(4)

# Examples that shows why it is better to use return in building functions 

value1 <- function(n) {
  n
  n*2
  x <- n
}

# no value return by the function. Function does someting but it only happen in the environment
value1(4)

# no matter what we will type as argument, function returns 2. 
value2 <- function(n) {
  n
  2
}

value2(3)
value2(10)
value2(2000)

# If we want to return many objects, we need to use list:
value2 <- function(n) {
  n
  x = 2*n
  list(n = n, x = x)
}

ewa<-value2(3)
ewa
# how to retrive waluse from a list?
ewa[1]

my.function <- function(a, b, c) {
  a + b + c
}

my.function(1, 2, 3)

# We can assign result to some variable
result <- my.function(1, 2, 3)
result

# Defense against user mistakes - defensive programming 
# simple example (but immature) defensive programming example
# But what happen if arguments are not numbers? Let's try it:
my.function(1, 2, '3')

# Obviously we need defense programming here. We will go back to this later on,
# now below we present some very basic example:
my.function2 <- function(a, b, c) {
  # if(class(a) == "numeric" & class(b) == "numeric" & class(c) == "numeric") {
  #   a * b + c
  # }
  if(is.numeric(a) & is.numeric(b) & is.numeric(c)) {
    a * b + c
  }
  
  else {
    print("arguments of the function aren't all numeric")
  }
}

# Now let's run some tests:
my.function2(2, 2, 2)
my.function2(2, 2, "2")


# What result would we expect if our function is vectorized?
# Let's notice, that our functions is vectorized
vector1 <- 1:5
vector2 <- 1:5
vector3 <- 1:5

# And test:
my.function(vector1, vector2, vector3)
vector1
vector2
vector3


# That they can have default values...

f.example <- function(a1 = 1, a2 = 5, a3 = 7) {
  print(a1)
  print(a2)
  print(a3)
}

# we do not need to fill the arguments for the function 
# default vaules are used
# of course we can change default values 
f.example()
f.example(a2 = 4)
my.function()

# You can check arguments of the function with args():
args(f.example)
args(randomForest)

# We can also declare some argument optional:
# they are not recquired to be filled 
f.example <- function(a1, a2, a3 = NULL){
  if(is.null(a3)){
    a1 + a2
  } else {
    a1 + a2 + a3
  } 
}

f.example(1, 2)
f.example(1, 2, 4)

# without it...
f.example <- function(a1, a2, a3){
  if(is.null(a3)){
    a1 + a2
  } else {
    a1 + a2 + a3
  } 
}

# here we did not define the default of a3 so we have mistake in a console
f.example(1, 2)

# however...
# here no default but we do not use a3 so it works 

f.example <- function(a1, a2, a3){
  a1 + a2
}
f.example(1, 2)

# This is called lazy evaluation.
# if the code is not run, it is not evaluated. 
# The correctness of the code is checked only after execution
# for some programmers it is not acceptable 

# Example of lazy evaluation in ggplot2:
library(ggplot2)

head(iris)

# This works:
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point()

# let's misspell name of one variable (on purpose) 
ggplot(data = iris, aes(x = Sepal.Length2, y = Sepal.Width, color = Species)) +
  geom_point()

# Former code result in error, but belowed does not:
p <- ggplot(data = iris, aes(x = Sepal.Length2, y = Sepal.Width, color = Species)) +
  geom_point()

# And now error is raised:
p

# why do we see error only after execution of p not in line 188?

# assigning a code to a variable is only so called a recipe for a chart, 
# there is no computation executed. 
# Only after evoking an object p the "recipe" is executed and evaluated  

################################################################################
# It's also possible to create wrapper functions:

# Let's study the example
x <- 1:100
y <- x^3

plot(x, y)
plot(x, y, type = 'l', col = 'red')

# let's create a wrapper:
myplot <- function(x, y){
  plot(x, y, type = 'l', col = 'red')
}

myplot(x, y)
# but what if there are some other parameters that you want to change as well??
# for example you want to make a line thicker (bigger)
# We have mistake because there is no such argument in our function
myplot(x, y, lwd = 2)
plot(x, y, type = 'l', col = 'red', lwd = 2)

myplot2 <- function(x, y){
  plot(x, y, type = 'l', col = 'red', lwd = 2)
}

myplot2(x, y)

# We want line type to be default:
# ... --> unlimited list of parameters 
# thanks to ... we can add any parameter that will be passed to the function inside the function 
myplot <- function(x, y, type = "l", ...) {
  plot(x, y, type = type, ...) # pass "..." to "plot" function
}

# Let's call the function
myplot(x, y)

# however, new function has a lot of limitation...
myplot(x, y, lwd = 4)

# ..which does not have original function
plot(x, y, lwd = 4, type = 'l') 

myplot(x, y, lwd = 4, col = 'red', main="Plot 1")

################################################################################
# function can be argument of other function:
# if we want a function that as arguments has some functions we use FUN
# this abbreviation is also used in apply family.

fun1 <- function(x, FUN, ...){
  FUN(x, ...)
}

# those examples are so simple and impractical but we need to go over them so you could understand the concept!


fun1(1:10, mean, na.rm = T)

fun1(letters, paste, collapse = ',')

paste(letters, collapse=',')

# Problems

# 1. Write a function which computes for a given vector of numbers median absolute
# deviation: https://en.wikipedia.org/wiki/Median_absolute_deviation

x <- 1:10

MAD <- function(vec) {
  stats::mad(vec, constant = 1)
}

MAD(x)

MAD2 <- function(vec) {
  MAD2 <- median(abs(vec - median(vec)))
  return(MAD2)
}

MAD2(x)
# Reminder list vs vectors?

vector_0<-c(1:10,2:20,3:30,4:40,5:50)

vector_1<-list(1:10,2:20,3:30,4:40,5:50)

vector_0
vector_1
vector_1[1]
vector_1[1][1]
vector_1[[1]][1]


for (i in 1:length(vector_1)) {
  
  print(fun1(vector_1[[i]], mean, na.rm = T))
  
}



# 2. Write a function which computes coefficient of variation:
# https://en.wikipedia.org/wiki/Coefficient_of_variation

# For test use following data:
library(MASS)
data(survey)

CV <- function(z) {
  a <- sd(z, na.rm = TRUE)
  b <- mean(z)
  return(a/b)
}

CV(survey$Age)

# 3. Review the code of the previous function. Include following functionalities:

# a) parameter, which allows user to decide, whether result will be printed as 
#    fraction or in percentages points.

CV2 <- function(z, frac = FALSE, perc = FALSE) {
  a <- sd(z, na.rm = TRUE)
  b <- mean(z)
  cv <- a/b
  if (frac == TRUE) {
    return(fractions(cv))
  } else if (perc == TRUE) {
    return(cv*100)
  }
}

CV2(survey$Age, TRUE)
CV2(survey$Age, FALSE, TRUE)
CV2(survey$Age, perc = TRUE)

# b) ability to control, whether NA's are included in computations.

CV3 <- function(z, frac = FALSE, perc = FALSE, na = FALSE) {
  a <- sd(z, na.rm = na)
  b <- mean(z, na.rm = na)
  cv <- a/b
  if (frac == TRUE) {
    return(fractions(cv))
  } else if (perc == TRUE) {
    return(cv*100)
  } else {
    return(cv)
  }
}

CV3(survey$Age, na = TRUE)


# c) write two versions of the function:
#     c1) first should work with vectors, thus:

CV3(survey$Height, na = TRUE)

#     c2) second should work with dataframe, thus

CV3.2 <- function(z, x, frac = FALSE, perc = FALSE, na = TRUE) {
  a <- sd(z[,x], na.rm = na)
  b <- mean(z[,x], na.rm = na)
  cv <- a/b
  if (frac == TRUE) {
    return(fractions(cv))
  } else if (perc == TRUE) {
    return(cv*100)
  } else {
    return(cv)
  }
}

CV3.2(survey, 'Age', perc = TRUE)

#############################################################################
# 4. Consider further extension of the function. Write a procedure, which will
# computes coefficient of variation of given continuous variable in subsamples 
# divided with respect to some given nominal variable. 
# cv_user2(survey, 'Age', 'Sex', na.rm = T)

# Variant 1.
# Use for loop and function unique()

cvSplit <- function(d, c, n, na = T) {
  n<-"Sex"
  c<-"Age"
  d<-survey
  
  nominalVar <- unique(d[,n])
  results <- c()
  for (i in 1:length(nominalVar)) {
    results[i] <- CV3.2(d[d[,n] == i, ], c, na =T)
    return(results[i])
  }
}


cvSplit(survey, 'Age', 'Sex')

# results <- numeric()
# results['Male'] <- cv_user(survey[survey[,'Sex'] == 'Male', ], 'Age')
# 
# results <- numeric()
# for (i in unique(survey[, 'Sex'])){
#   results[i] <- cv_user(survey[survey[,'Sex'] == i, ], 'Age', na.rm = T)
# }
# results




# Variant 2.
# Use split() function and for loop

datasets <- split(survey, survey[, 'Sex'])

datasets[['Male']]
datasets[['Female']]

cv4.2 <- function(d, c, n, na = T) {
  datasets <- split(d, d[, n])
  for (i in datasets) {
    results[i] <- CV3.2(datasets[i], c, na = na)
    return(results)
  }
}

cv4.2(survey, 'Age', 'Sex', na = T)

# 4. Write a function, which will work with any dataset (let’s say a data.frame object) and for each integer
# variable in the database create a boxplot, for numeric variable histogram, and for factor variables barplot.
# For testing process you can use Cars93 database.

draw <- function(d){
  if(is.data.frame(d)) {
    for (i in 1:ncol(d)) {
      if (is.integer(d[,i])) {
        boxplot(d[,i])
      } else if (is.numeric(d[,i])) {
        hist(d[,i])
      } else if (is.factor(d[,i])) {
        barplot(table(d[,i]))
      } else {
        print("Variable != integer | numeric | factor")
      }
      
    }
  }
}

draw(Cars93)
draw(survey)

# 5. Write a function, which will divide dataset with respect to some
# nominal variable and run regression with given formula for each subset.
# Function should return a list with a results of regression for each subset
splitreg <- function (df, n) {
  result <- list()
  subsets <- split(df$n, n, drop = T)
  
}
  
splitreg(survey, 'Sex')
  
lm(Age ~ Sex, data = survey)
