## Exercise 1 
# Write an if statement, which will return sum of a and b variables (if they are 
# numbers), or their concatenation (if they are strings) and "error" in other 
# cases.
# Tip: concatenation function is paste0() or paste()

# Solution
a <- 3
b <- 8
if (is.numeric(a) & is.numeric(b)) {
  sum(a,b)
} else if (is.character(a) & is.character(b)){
  paste(a, b)
} else {
  "error"
}



## 1.2. ifelse function - vectorised equivalent
# ifelse({condition}, {what if YES}, {what if NO})
# Result is a vector with the same dimensions as the one in the condition.
# waring message wht is disturbing, condition is lenght >1 only first element will be used


if (1:5 %% 2 == 1) { print('odd')} else {print('even')}

# produce as amny values as the condition
# condition has five elements --> result will also have five elements
# Example:
ifelse(1:5 %% 2 == 1, "odd", "even")

# Symbol x %% y = x mod y:
8 %% 2
7 %% 3

#### nested ifelse

df <- data.frame(team = c('A', 'A', 'B', 'B', 'B', 'C', 'D'),
                 points = c(4, 7, 8, 8, 8, 9, 12),
                 rebounds = c(3, 3, 4, 4, 6, 7, 7))


df$rating <- ifelse(df$points > 7, 'great', 'bad')

#create new column in data frame
df$rating <- ifelse(df$team == 'A', 'great',
                    ifelse(df$team == 'B', 'OK', 'bad'))


## Exercise 2. ## 
# Write a loop, which will work with any dataset (which is a data.frame object) 
# and for each integer variable in the database create a boxplot, for numeric 
# variable histogram, and for factor variables barplot. For testing process you 
# can use survey database.

# Dataset for examples:
# firstly perform operations from line 373 to 376
library(MASS)
data(survey)
head(survey)
help(survey)

# I option: to loop over the column number
columns <- ncol(survey)

for (i in 1:ncol(survey)) { 
  if (is.numeric(survey[, i])) {
    boxplot(survey[, i])
  } else if (is.numeric(survey[, i])) {
    hist(survey[, i])
  } else if (is.factor(survey[, i])) {
    barplot(table(survey[, i])) 
  }
}

# II option: to loop over the column name
names <- colnames(survey)

for (i in names) { 
  if (is.numeric(survey$i)) {
    boxplot(survey$i)
  } else if (is.numeric(survey$i)) {
    hist(survey$i)
  } else if (is.factor(survey$i)) {
    barplot(table(survey$i)) 
  }
}
# Hints for graphs:
# boxplot(survey$Wr.Hnd)
# boxplot(survey[, 2])
# hist(survey$Wr.Hnd)
# hist(survey[, 2])
# barplot(table(survey$Sex))
# barplot(table(survey[, 2]))

# 1. Write a function which computes for a given vector of numbers median absolute
# deviation: https://en.wikipedia.org/wiki/Median_absolute_deviation

x <- 1:10


# Reminder list vs vectors?

vector_0<-c(1:10,2:20,3:30,4:40,5:50)

vector_1<-list(1:10,2:20,3:30,4:40,5:50)

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

cv <- function(z, na.rm = T) {
  a <- sd(z, na.rm = na.rm)
  b <- mean(z, na.rm = na.rm)
  return(a/b)
}

cv(survey$Age)

# 3. Review the code of the previous function. Include following functionalities:

# a) parameter, which allows user to decide, whether result will be printed as 
#    fraction or in percentages points.
# b) ability to control, whether NA's are included in computations.
# c) write two versions of the function:
#     c1) first should work with vectors, thus: cv(survey$Height)

cv2 <- function(z, na.rm = T, frac = F, perc = F) {
  a <- sd(z, na.rm = na.rm)
  b <- mean(z, na.rm = na.rm)
  cv <- (a/b)
  if (frac == T) {
    return(fractions(cv))
  } else if (perc == T) {
    return(cv*100)
  } else {
    return(cv)
  }
}

cv2(survey$Age, frac = T)
cv2(survey$Age, perc = T)

#     c2) second should work with dataframe, thus

cv_user <- function(z, x, na.rm = T, frac = F, perc = F) {
  a <- sd(z[,x], na.rm = na.rm)
  b <- mean(z[,x], na.rm = na.rm)
  cv <- (a/b)
  if (frac == T) {
    return(fractions(cv))
  } else if (perc == T) {
    return(cv*100)
  } else {
    return(cv)
  }
}
cv_user(survey, 'Age')


# 4. Consider further extension of the function. Write a procedure, which will
# computes coefficient of variation of given continuous variable in subsamples 
# divided with respect to some given nominal variable. 

# Variant 1.
# Use for loop and function unique()

cv_user2 <- function(z, c, n, na.rm = T, frac = F, perc = F) {
  results <- numeric()
  for (i in unique(z[,n])){
    results[i] <- cv_user(z[z[,n] == i, ], c, na.rm = T, frac = T, perc = perc)
  }
  return(results)
}
cv_user2(survey, 'Age', 'Sex', na.rm = T, frac = T)

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



# 4. Write a function, which will work with any dataset (let’s say a data.frame object) and for each integer
# variable in the database create a boxplot, for numeric variable histogram, and for factor variables barplot.
# For testing process you can use Cars93 database.

manyplot <- function(df) {
  if (is.data.frame(df)) {
    for (i in 1:ncol(df)) {
      if (is.integer(df[,i])) {
        boxplot(df[,i])
      } else if (is.numeric(df[,i])) {
        hist(df[,i])
      } else if (is.factor(df[,i])) {
        barplot(table(df[,i]))
      } else {
        return('unknown data type')
      }
    }
  } else {
    return('is not data.frame')
  }
}

manyplot(Cars93)

# 5. Write a function, which will divide dataset with respect to some
# nominal variable and run regression with given formula for each subset.
# Function should return a list with a results of regression for each subset


# Exercise 1.
# Define operator %sample%, which will return random sample of size n from given 
# vector. Exemplary call:

1:100 %sample% 10

# Hint: sample() function might be useful.


# Exercise 2.
# Row sums can be tricky. Ordinary `+`` operator is dangerous, 
# when NA's occurs in dataset. On the other hand, rowSums and apply functions are
# relatively incovenient. Define new binary operator %+na% which ignores missings 
# when add values to each others, e.g.:

2 + NA 
# [1] NA

2 %+na% NA
# [1] 0

# Exercise 3. 
# Create operator which works like LIKE operator in SQL.

cities <- c('Barcelona', 'Rome', 'Warsaw')

cities %LIKE% 'War'
# [1] c(F, F, T)


# Exercise 1.
# In below function formula for RMSLE  is implemented:

my_rmsle <- function(y, pred) {
  # Formula available here:
  # https://www.kaggle.com/c/ashrae-energy-prediction/discussion/113064
  sqrt(sum((log(pred + 1)-log(y + 1))**2)/length(y))
}

# - add assertions checking the correctness of type and class of input data,
# - add assertions checking the correctness of values (should be greater than zero)
# - add handling of missing data (display information about the number
#   of missing observations, eliminate them from the calculation),
# - display a warning if the number of non-missings is greater than 5.
# - add assertions checking equal length of vectors before and after eliminating missing data



# Exercise 2.
# Write a function which computes glm logistic model, prints summary of the model and
# returns invisibe object of the model. 


# Exercise 7.1
# Check the time efficiency of various formulas calculating
# a square root from a vector of values. 
# Compare results for vectors of various lengths and types 
# (integer vs double).
# Check whether different formulas give exactly the same result.

# Sample methods for calculating the square root

x <- 1:10

sqrt(x)
x**(0.5)
exp(log(x) / 2)

# some other?



# Exercise 7.2.
# a) Compare the time efficiency of different variants 
#    of referrencing to a single element of a data.frame 
#    (see below)
#    https://stat.ethz.ch/R-manual/R-devel/library/base/html/base-internal.html

myData <- data.frame(x = rnorm(1e5))

myData$x[10000]
myData[10000, 1]
myData[10000, "x"]
myData[[c(1, 10000)]]
myData[[1]][10000]
.subset2(myData, select = 1)[10000]

# some other?

# b) rewrite the above code checked by the profvis()
#    function using the most efficient type of referncing
#    to a single element from a data.frame().
#   Is it much faster? Faster than using a matrix?





# Exercise 7.3
# Write two (or more) variants of the function finding and displaying
# all prime numbers from the interval [2, n], where n will be
# the only argument of the function.

# In one variant, use loops all over the vector,
# in the second you can use the algorithm known 
# as the Sieve of Eratosthenes - its pseudocode
# can be found here:
# https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes

# Compare the time efficiency of both functions 
# BEFORE and AFTER precompilation to bytecode. 
# Check if the results from both functions are identical.




# Exercise 7.4.
# Perform code profiling of both functions from
# exercise 7.3 Which parts of them take the most time?



