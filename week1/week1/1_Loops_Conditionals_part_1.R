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

## 1. If statement: ------------------------------------------------------------

# One of the core aspects of programming (in any language) is the use of
# the if statements. Depending on what logical value we want to get, we want
# our program to do one or another set of instructions.

## 1.1 The if instruction,
# Syntax: if ( condition ) { what if YES } else { what if NO }
# Syntax for if statement with multiple conditions :

# if ( CONDITION1 ) { what if YES } else if ( CONDITION2 ) { what if YES} else if ... else 
# { what in this case }

### Relational and logical expressions - reminder:
# ==
# !=
# <=
# <
# >=
# >
# logical operators 
# & conjunction (and)
# | alternative (or)
# is.na()

# is.nan()

pi / 0 ## = Inf a non-zero number divided by zero creates infinity
0 / 0  ## =  NaN

1/0 + 1/0 # Inf
1/0 - 1/0 # NaN

is.nan(0 / 0)
is.nan(pi / 0 )

# is.finite()
is.finite(pi / 0 )

is.infinite(pi / 0 )

is.finite(100)

# is.character()

is.character("Programming in R")

is.character(3)

# is.numeric()
# is.double()
# almost for each type of R object we have is.object_() function
# is.data.frame()

iris_1<-iris

is.data.frame(iris_1)


################################################################################

# xor()
# any()
# all()

T | T
T | F
F | T
F | F

xor(T, F)
xor(F, T)
xor(T, T)

(T & !F) | (!F & T) 

# all(..., ... , ... , ....)
# any(..., ..., ... , ...)
# Here we have three elements

first<-any(1 + 2 == 3, 2 + 3 == 4, 3 + 4 == 5)

second<-2 + 3 == 5

third<-3 + 4 == 7

all(first, second, third)

all(any(1 + 2 == 3, 2 + 3 == 4, 3 + 4 == 5), 2 + 3 == 5, 3 + 4 == 7)


# Let's remind that in R we use | symbol for disjunction (fot vectors)
# or || (for single values), and & and && for conjunction. Of course,
# we can use these symbols alternatively for one-element vectors.
# We can also use the all() and any() function meaning respectively
# conjunction and disjunction for more than two conditions.

c(TRUE, FALSE) | c(FALSE, FALSE) # vectorized (elementwise)
c(TRUE, FALSE) & c(FALSE, TRUE)

c(TRUE, FALSE) || c(FALSE, FALSE)  # not vectorized (does not accept vector as an argument)
c(TRUE, FALSE) && c(FALSE, TRUE)
c(TRUE, FALSE) && c(TRUE, TRUE)

# First example of the if statement:
# one liner not recommended 
if (2 + 2 == 4 | 1 + 3 == 5) "Hello" else "World"
if (2 + 2 == 4 & 1 + 3 == 5) "Hello" else "World"

# With curly brackets
if (2 + 2 == 4 | 1 + 3 == 5) {
  "Hello"
} else {
    "World"}

# with curly brackets

if (2 + 2 == 4 & 1 + 3 == 5) {
  "Hello"
  }else {
    "World"
  }


# The longer version (but else if can be unlimited): 

# if (<logical_expression>){ # mandatory
#    <functions and commands>
#    <functions and commands>
#    <functions and commands>
# } else if (logical_expression>) { # optional
#    <functions and commands>
#    <functions and commands>
#    <functions and commands>
# } else if (logical_expression>) { # optional
#    <functions and commands>
#    <functions and commands>
#    <functions and commands>
# } else { # optional
#    <functions and commands>
#    <functions and commands>
#    <functions and commands>
# }

# Very common constructions are:

# if (<logical_expression){ # mandatory
#    <functions and commands>
#    <functions and commands>
#    <functions and commands>
# }

# if (<logical_expression){ # mandatory
#    <functions and commands>
#    <functions and commands>
#    <functions and commands>
# } else { # optional
#    <functions and commands>
#    <functions and commands>
#    <functions and commands>
# }

# Other examples
a <- 3
b <- 1
c <- 4

matrix1 <- matrix(0, nrow = 5, ncol = 2)
matrix1

if (a == 3) {
  matrix1[a, 1] <- 100
}
matrix1

# One liner, same as above:
if (a == 3) matrix1[a, 1] <- 100

# If there is oneliner, I can rewrite into to lines without curly brackets:
if (a == 3) 
  matrix1[a, 1] <- 500

if (b == 2) {
  matrix1[b, 1] <- 1
} else {
  matrix1[b, 1] <- 101
}
matrix1

if (a == 4 | (b == 2 & c == 4)) {
  matrix1[a, 1] <- 105
} else if (c == 4){
  matrix1[c, 1] <- 110
} else {
  matrix1[b, 1] <- 101
}
matrix1


## Exercise 1 ##

# Write if statement, which will return sum of a and b variables (if they are 
# numbers), or their concatenation (if they are strings) and "error" in other 
# cases.
# Tip: concatenation function is paste0() or paste()

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



## 2. For loop -----------------------------------------------------------------

# Syntax:
# for (i in {set of indices}){ COMMAND }

# Literally: for i = 1 to 10 make operations inside the loop (limited by brackets)
wek <- 1:20
wek

for (i in 1:10) {
  # wek
  # commands in loop, for example:
  print(wek)
}

for(i in 1:10) {
  print(wek[i+10])
}

for(i in 1:25) {
  print(wek[i])
}

for(i in 1:length(wek)) {
  print(wek[i])
}

# or along the vector
for(i in seq_along(wek)) {
  print(wek[i])
}

# seq_along is more elegant and a bit more robust than 1:length(x) expression
1:length(c())
seq_along(c())

# we can select values manually
for(i in c(2, 8, 14, 20)) {
  print(wek[i])
}

# we can limit our condition so it will work the way we want it to work
interesting_numbers <- c(2, 8, 14, 20)

# We can iterate over value of vector
for(i in interesting_numbers) {
  print(wek[i])
}

# or increase by 2
for(i in seq(1, length(wek), by = 2)){ 
  print(wek[i])
}

# or iterate with characters
for(i in letters){ 
  print(paste0('section_',i))
}

# break instruction breaks loop:
for(i in 1:25) {
  if (i > 10) {
    print('Loop is broken!')
    break # stop the loop
  }
  print(wek[i])
}

# next instruction skip the rest of the code and move to the next iteration:
for(i in 1:25) {
  if (i > 10 & i < 20) {
    print('move to the next iteration')
    next
  }
  print(wek[i])
}

# Loops can be nested:
matrix1 <- matrix(0, 10, 2)
number <- 1

for(i in 1:nrow(matrix1)){
  for(j in 1:ncol(matrix1)){
    matrix1[i,j] <- number
    number <- number + 1
  }
}
matrix1

# in loops is very covienient to use placeholders:

# concatenation of strings
for (i in 1:10){
  print(paste0('This is placeholder: ', i, '.'))
}

# install.packages('stringr')
library(stringr)

for (i in 1:10){
  print(str_interp('This is placeholder: ${i}.'))
}

# install.packages('glue')
library(glue)

for (i in 1:10){
  print(glue('This is placeholder: {i}'))
}

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







