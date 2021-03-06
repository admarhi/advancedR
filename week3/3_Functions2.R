#---------------------------------------------------------#
#                 Advanced Programming in R               #
#              3. Functional programming part 2           #
#                  Academic year 2019/2020                #
#               Piotr Ćwiakowski, Piotr Wójcik            #
#---------------------------------------------------------# 

### 1. Binary operators --------------------------------------------------------

# binary operators (eg. +, -, %%, %in%, %>%) are in fact functions, which have two 
# arguments, one the LHS (left hand side) one on the RHS. User defined operators
# should start and end with percent symbols. Let's learn how to right them on our 
# own.

# first example - sum operator:
# name of our operator must me embeded in apostrophes
# name of operator as an object  = function that defines what it is doing 
# %content% - not to condue users from othr operators

`%+%` <- function(x, y) sum(x, y)
# your own operator with %%

5 %+% 6
5 + 6

# Watch out - it is easy to substitute original operator!
# risky action!!!!!!
`+` <- function(x, y) sum(x, -y)
5 + 6

# let's delete it at never repeat it ever again.
rm(`+`)

# this one is pretty helpful as well in filter (dplyr)
# %in% 
`%notin%` = Negate(`%in%`)


# another example - imitation of head() function:
head(1:10, 4)
head(iris, 4)

`%h%` <- function(x, y) head(x, y)

# 4 observations from iris
iris %h% 4
library(ggplot2)
diamonds %h% 15

# not mandatory but for eager students:
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


### 2. Defensive programming ---------------------------------------------------

# According to wikipedia:
# 
# Defensive programming is a form of defensive design intended to ensure the continuing 
# function of a piece of software under unforeseen circumstances. Defensive programming 
# practices are often used where high availability, safety, or security is needed.
  


# 2.1. Error handling ----------------------------------------------------------

Sys.setenv(LANG = 'en')

f1 <- function(x){
  sqrt(x) # for characters function stops here 
  print(x)
}

f1(3)
# Error:
f1('Ala')

# Let's run again with try() function: 
f1 <- function(x){
  try(sqrt(x)) # try if possible, it produe error if it is not numeric 
  print(x)    # print argument in both cases 
}
# Run:
f1('Ala')
f1("3")
# So, try() function:
# 1) printed error message,
# 2) allowed function to work further. 

# But only errors are taking care of:
# not error but warning 
f1(-10)

# by the way, we can change importance of this error:
options(warn = 2) # increase the importance of warnings in global environment 
f1(-10)

# by default:
options(warn = 1)
f1(-10)

# The result of try function can be store in variable"
good = try(2 + log(2))
good

bad = try(2 + log('2'))
bad
# functionnreturn object which has error
# class is try-error
# attribute condition 

# It can be executed silently:
bad = try(2 + log('2'), silent = T)

# Let's investigate object returned after error:
bad

# Attributes (class and condition):
attributes(bad)
class(bad)

# We can use it to modify message for user:
# it might be useful to create if conditions 
if(class(bad) == "try-error") {
  print("Erro no 1234: check company policy handbook p. 567")
}

# In the code below try() function is used to check where error occurs in
# apply function:
elements <- list(1:10, c(-1, 10), c(TRUE, FALSE), letters)
results <- lapply(elements, function(x) sqrt(x)) 
# error prevents form displaying valid results in lapply
# difficult to catch error 

sqrt(elements[[1]])
sqrt(elements[[2]])
sqrt(elements[[3]])
sqrt(elements[[4]])



# We can include the try() error handler:
results <- sapply(elements, function(x) try(sqrt(x), silent = TRUE))
# we have objects 


# Now we are able to detect fields which result in critical error:
# we can check which fielsd of results cause issue 
is.error <- function(x) inherits(x, 'try-error')
lapply(results, is.error)

# A bit more universal function is tryCatch(), which handles: errors, warnings, 
# messages. User can choose what kind of behavior will occur if any of the above
# happen.
example <- function(code) {
  tryCatch(code,
           error = function(c) "error",
           warning = function(c) "warning",
           message = function(c) "message"
  )
}

# tryCatch - wanings, errors, messages 
example(log(-2))
example(log('-2'))
example(library(dplyr))

# 2.2. Assertions --------------------------------------------------------------

# While creating functions, it is recommended to put at the beginning of the code
# conditions which check whether arguments of the function have correct type, class
# and format. This conditions are called assetions.
# 
# They are useful because:
# - prevent from making unnecesary computations (if arguments have wrong form,
#   estimations, even if are partially correct, will be useless)
# - allows to correct mistakes quickly,
# - allows to design messages for users more intuitive than standard R errors and 
#   warnings.


# For examples, we will use following procedures which imitates errors, warnings
# and messages:
stop("!")
warning("!")
message("!")

# Generally, we should use errors if exception is critical, and warning if there
# is a potential problem, event though arguments and data fulfilled every necessary
# requirement.

# For example:

log_user <- function(x){
  if(!is.numeric(x)){
    stop('Argument is not a number')
  }
  if(x < 0){
    warning('Argument is negative')
  } else{
    message('Everything is just fine. Keep calm and compute.')
  }
  log(x)
}

log_user(10)
log_user('10')
log_user(-10)

# Because if and stop() are used frequently together, there is stopifnot() function
# available:
f1 <- function(x){
  stopifnot(is.numeric(x)) # stop if not true 
  sqrt(x)
}
f1('Ala')
f1(10)


# With all():
f1 <- function(x, y, z){
  stopifnot(all(is.numeric(x), is.numeric(y), is.numeric(z)))
  sqrt(c(x, y, z))
  
}
f1('Ala', 2, 3)

# with all.equal()
f1 <- function(x, y){
  stopifnot(all.equal(x,y))
  sqrt(c(x, y))
}
f1(1, 2)

# Another assertions can be found in package asserthat or testit:

install.packages('assertthat')
library(assertthat)


assert_that() # stopifnot(), but allows for user defined messages
see_if() # returns logical value, message is only an attribute
validate_that() # returns true if condition is fulfilled and error message in opposite case.

f1 <- function(x){
  assert_that(is.numeric(x), msg = 'Rookie mistake!')
  sqrt(x)
}
f1('Ala')

f1 <- function(x){
  see_if(is.numeric(x))
  print(see_if(is.numeric(x)))
  sqrt(x)
}
f1('Ala')

f1 <- function(x){
  validate_that(is.numeric(x))
  print(validate_that(is.numeric(x)))
  sqrt(x)
}
f1('Ala')


# Other assertions:
# is.flag(x): is x TRUE or FALSE? (a boolean flag)
# is.string(x): is x a length 1 character vector?
# has_name(x, nm), x %has_name% nm: does x have component nm?
# has_attr(x, attr), x %has_attr% attr: does x have attribute attr?
# is.count(x): is x a single positive integer?
# are_equal(x, y): are x and y equal?
# not_empty(x): are all dimensions of x greater than 0?
# noNA(x): is x free from missing values?
# is.dir(path): is path a directory?
# is.writeable(path)/is.readable(path): is path writeable/readable?
# has_extension(path, extension): does file have given extension?

install.packages('testit')
library(testit)

# testit package also includes functions to detect,
# whether there was an error or warning was generated

has_error(10 + 10)

has_error(10 + "10")

has_warning(10 + 10)

has_warning(mean(NULL))


# Sometimes, if we want to be sure that some code will be executed, before function
# will ends (even when an error occured) we can use expression on.exit():

# par(mar = c(10, 9, 9, 7) -> margins for the plot 

plot_with_big_margins <- function(...)
{
  old_pars <- par(mar = c(10, 9, 9, 7))  
  on.exit(par(old_pars)) # it will be resotred even though plot was not created 
  plot(...)
}

# Now originally margins are restored after the function call: 
plot_with_big_margins(with(cars, speed, dist))
plot(with(cars, speed, dist))

#### End for today##################################
# More examples can be found here:
# https://stackoverflow.com/questions/28300713/how-and-when-should-i-use-on-exit

### 3. invisible() -------------------------------------------------------------

# Sometimes it is convenient to return as a function result the object that which 
# is invisible. This is especially useful for functions that return result, which 
# can be assigned to some object, but if it is not assigned, will not be displayed 
# in the console.


reg_plot <- function(formula, data) {
  # estimate regression model
  fit = lm(formula, data)
  # plot diagnostic plots residuals
  par(mfrow=c(2,2)) # Change the panel layout to 2 x 2
  plot(fit)
  par(mfrow=c(1,1)) # Change back to 1 x 1
  # generate summary
  print(summary(fit))
  # return the model as "invisible" object
  invisible(fit)
}

# Example:
reg_plot(Sepal.Length ~ ., iris)

# but...
model <- reg_plot(Sepal.Length ~ ., iris)

# here more about diagnostics plots:
# https://data.library.virginia.edu/diagnostic-plots/

# Real case example of invisible() function is here:
hist(iris$Sepal.Length)

# however we can assign result to a plot...
histogram <- hist(iris$Sepal.Length)

# ... which is a list containing information bins:
str(histogram)



# Exercises

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




 