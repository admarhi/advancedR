#---------------------------------------------------------#
#                 Advanced Programming in R               #
#             9. RCpp2: advanced usage of Rcpp            #
#                  Academic year 2021/2022                #
#                Maria Kubara, Ewa Weychert               #
#        materials by: Piotr Wójcik, Piotr Ćwiakowski     #
#---------------------------------------------------------#    

# lets load needed packages

library(Rcpp)
library(rbenchmark)

#------------------------------------------------------------
# 1. Using Rcpp sugar

# Rcpp package provides a lot of syntactic
# “sugar” (code simplification) which make
# the usage of C++ under R very sweet :).

# Rcpp sugar makes it possible to write efficient C++ 
# code that looks ALMOST IDENTICAL as R code.

# Sugar functions aren’t always faster than pure C++,
# but the authors of Rcpp package work on optimising 
# this approach, to make Rcpp coding simpler.


# for example all the basic arithmetic and logical operators 
# are vectorised in Rcpp:
# +, *, -, /, <, <=, >, >=, ==, !=, !

# one can also use summary functions on vectors
# in the same way as they are used in R, e.g.
# sum(v), mean(v), median(v), sd(v), sign(v),
# sqrt(v), pow(v, n) and many others

# for details check useful R-like functions in Rcpp sugar:
# https://teuder.github.io/rcpp4everyone_en/210_rcpp_functions.html#list-of-r-like-functions
# https://thecoatlessprofessor.com/programming/cpp/unofficial-rcpp-api-documentation/#sugar
# https://gallery.rcpp.org/articles/sugar-for-high-level-vector-operations/
# http://dirk.eddelbuettel.com/code/rcpp/Rcpp-sugar.pdf


# lets write a simple function that
# returns a square of a single number
# (defined for a scalar): squareCpp() 

cppFunction("double squareCpp(double x) {
              double result = x * x;
              // alternative: pow(x, 2);
              return result;
             }")

# and check how it works

squareCpp(1.234567)

# but cannot be used on a vector of inputs

squareCpp(c(1, 2, 3, 4, 5, 6, 7))

# which is not much useful

# lets write the vector variant of the function

# in pure C++ this would require a loop

cppFunction("NumericVector squareCppVec(NumericVector x) {
               int n = x.size();
               NumericVector result(n);
               for(int i = 0; i < n; i++) { 
                   result[i] = x[i] * x[i]; 
                   }
                return result;
             }")

squareCppVec(c(1, 2, 3, 4, 5, 6, 7))

# this function accepts also scalars 
# (as vectors of length 1)

squareCppVec(1.234567)

# but the code might look more similar to R 
# thanks to Rcpp sugar (multiplication is vectorised)

cppFunction("NumericVector squareCppVec2(NumericVector x) {
                return x * x;
             }")

squareCppVec2(c(1, 2, 3, 4, 5, 6, 7))

# one can also use the vectorized pow(v, n) function
# here we avoid creating intermediate objects

cppFunction("NumericVector squareCppVec3(NumericVector x) {
                return pow(x, 2);
             }")

squareCppVec3(c(1, 2, 3, 4, 5, 6, 7))

# lets check if using sugar approach changes the time efficiency

benchmark("squareCppVec" = squareCppVec(c(1, 2, 3, 4, 5, 6, 7)),
          "squareCppVec2" = squareCppVec2(c(1, 2, 3, 4, 5, 6, 7)),
          "squareCppVec3" = squareCppVec3(c(1, 2, 3, 4, 5, 6, 7)),
          replications = 100000
          )

# the speed after using sugar is comparable with pure C++


#-----------------------------
# Lets define a function that calculates
# Mean Absolute Percentage Error (MAPE):
# mean [abs(real_i - forecast_i)/real_i]

# lets add also simple error handling as both 
# input vectors should have the same length

# function in R

mapeR <- function(real, forecasts) {
  if (length(real) != length(forecasts)) 
    stop("The length of real and forecasts must be the same.")
  
  mean(abs(real - forecasts)/real)
}

# C++ with a loop
# stop() - prints an error message and stops execution
# warning() - displays message, but does not stop

cppFunction('double mapeCpp(NumericVector real, NumericVector forecasts) {
                int nf = forecasts.size();
                int nr = real.size();
                if (nf != nr) {
                   stop("The length of real and forecasts must be the same.");
                }
                double mape = 0.0;
                for(int i = 0; i < nf; i++) {
                // use abs for integer and fabs for double values
                // these two functions work on scalars
                   mape += fabs(real[i] - forecasts[i])/real[i];
                }
                return mape/real.size();
            }')

# Remember - if we want to calculate the absolute value of a scalar
# in C++ and get the result of class double, 
# we must use fabs() or std::abs()
# Using just abs() returns the value of type "int"
# - rounded to integer!

# sugar version of C++ function as short as possible

cppFunction('double mapeCppSugar(NumericVector real, 
                                 NumericVector forecasts) {
            if ( forecasts.size() != real.size() ) {
               stop("The length of real and forecasts must be the same.");
            }
            return mean(abs(real - forecasts)/real);
            // abs() is a function from Rcpp sugar which works on vectors
            }')

# here it is appropriate to use abs() function - we work on vectors here
# so function abs() from Rcpp sugar will be used which returns a vector 
# containing the absolute value of each element of vector v.

# see how functions work on artificially generated data

set.seed(1234556789)

r <- rnorm(1000) # "real" values

f <- rnorm(1000) # "forecasts"

# lets check if result is the same

mapeR(r, f)
mapeCpp(r, f)
mapeCppSugar(r, f)  

# how it works when the length of vectors differs?

mapeR(r, f[-1])
mapeCpp(r, f[-1])
mapeCppSugar(r, f[-1])  

# comparison of efficiency

benchmark("R" = mapeR(r, f),
          "Cpp" = mapeCpp(r, f),
          "CppSugar" = mapeCppSugar(r, f),
          replications = 50000)[, 1:4]


# not always a function written in C++ will work
# (much) faster than its R equivalent.
# Even if it works several times faster, one needs
# to take into account that writing a counterpart
# in C++ also takes some time.

# In many situations Rcpp sugar allows to make the code
# almost as simple as the pure R code, but not always


# let's write a function that calculates the coefficient 
# of variation (CV = 100 * stdev/mean) for every column
# of a numeric matrix
# (for convenience we will calculate standard deviation 
# (variance) based on the formula: var = mean(x^2) - (mean(x))^2

colCVsR <- function(x) {
  n = nrow(x)
  means_x = colMeans(x)
  means_x2 = colMeans(x**2)
  
  sds = sqrt(n/(n-1) * (means_x2 - means_x**2) )
  
  CVs = 100 * sds/means_x
  
  return(CVs)
}

# C++ equivalent of the colCVs(x) function

cppFunction('NumericVector colCVsCpp(NumericMatrix x) {
                int nrow = x.nrow(), ncol = x.ncol();
                NumericVector means_x(ncol), means_x2(ncol), 
                              sds(ncol), colCVs(ncol);
            
                for (int j = 0; j < ncol; j++) {
                   // initialize column sum by 0
                   double sum = 0, sum2 = 0;
                   for (int i = 0; i < nrow; i++) {
                       // aggregate x values
                       sum += x(i, j);
                       // calculate also sum of squares
                       sum2 += pow(x(i, j), 2);
                       }
                   means_x[j] = sum/nrow;
                   means_x2[j] = sum2/nrow;
                   sds[j] = sqrt( double(nrow)/(nrow-1) * (means_x2[j] - pow(means_x[j], 2)) );
                   colCVs[j] = 100 * sds[j]/means_x[j];
                   }
               return colCVs;
            }')


# below the same function in a sugar version

# CAUTION!
# function pow(x, n) and multiplication (*) operate 
# on vectors and cannot be applied on matrices,
# so we need to use one loop inside anyway

cppFunction('NumericVector colCVsCppSugar(NumericMatrix x) {
               int n = x.nrow(), ncol = x.ncol();
               // matrix for squared values of x
               NumericMatrix x2(n, ncol);
               NumericVector means_x(ncol), means_x2(ncol), 
                             sds(ncol), colCVs(ncol);
               // raise all elements of matrix x to power 2
               // loop over columns, but pow() works on vectors now
               for (int j = 0; j < ncol; j++) {
                  // how to refer to a single column/row from a matrix
                  x2( _ , j ) = pow(x( _ , j ), 2);
              }
               // then sugar function colMeans() used
               means_x = colMeans(x);
               means_x2 = colMeans(x2);
               sds = sqrt( double(n)/(n-1) * (means_x2 - pow(means_x, 2.0)));
               colCVs = 100 * sds/means_x;
              
               return(colCVs);
            }')

# new elements:
# refering to the whole column of a matrix: m(_, j)
# refering to the whole row of a matrix: m(i, _)
# colMeans() sugar function

# lets create a large matrix with 10 columns

set.seed(987654321)

m <- matrix(rnorm(5e5),
            ncol = 10)

colCVsR(m)
colCVsCpp(m)
colCVsCppSugar(m)


benchmark("R" = colCVsR(m),
          "Cpp" = colCVsCpp(m),
          "CppSugar" = colCVsCppSugar(m),
          replications = 1000)[,1:4]

# in this case sugar does not seem to be efficient...


#-----------------------------------------------------------------------#

# sugar functions also allow to cope with missing values easily

# there are vector functions related to logical values:
# is_na(v), is_nan(v), is_false(v), is_true(v),
# all(v), any(v), ifelse(v, x1, x2)

# lets simulate a vector with missings

set.seed(987654321)

x_val <- rnorm(10)

x_val[c(3, 5, 9)] <- NA

# sugar function mean() does not allow 
# to automatically cope with missing values

cppFunction('double myMeanNACppSugar(NumericVector x) {
                return mean(x);
             }')

myMeanNACppSugar(x_val)

# we need to do it using another function in addition

# fortunately there are sugar functions that help
# to cope with NAs and Inf values simply

# na_omit(v), is_finite(v), is_infinite(v),

cppFunction('double myMeanNACppSugar2(NumericVector x) {
                return mean(na_omit(x));
             }')

myMeanNACppSugar2(x_val)



#-----------------------------------------------------
# sampling and bootstrapping

# In many algorithms/applications we need to 
# use random samples 

# this is commonly used in simulations
# (e.g. option pricing in finance),
# assessing characteristics of parameters
# without known distributions or in small samples

# bootstrapping requires repetitive drawing
# of random samples of the same size as the
# whole dataset/vector (with replacement)
# https://en.wikipedia.org/wiki/Bootstrapping_(statistics)

# you may know it from ML algorithms called
# bagging (bootstrap averaging) where 
# random forest is the most known example

# lets write a function that uses bootstrapping
# (with n repetitions) to calculate 95% 
# interval for the median of x


# as there is no built-in function returning
# quantiles in Rcpp we will use a simplified approach 
# - sort the bootstrap results in increasing order
# and take observation of index ceiling(n * (1-clevel)/2)
# and floor(n * (1-(1-clevel)/2))


x <- 1:20

# R 

bootMedianCI_R <- function(x, n, clevel = 0.95) {
  medians = array(NA, n)
  size_x = length(x)
  # repeat sampling n times
  for (i in 1:n) {
    bsample_x <- sample(x, size_x, replace = TRUE)
    # each time save the median of the sample
    medians[i] = median(bsample_x, na.rm = TRUE)
  }
  # calculate the quantiles in a simplified way
  lower = ceiling(n * (1 - clevel)/2)
  upper = floor(n * (1 - (1 - clevel)/2))
  
  medians = sort(medians)
  
  ci = medians[c(lower, upper)]
  return(ci)
}

bootMedianCI_R(x, 1000)

# C++


cppFunction('NumericVector bootMedianCI_Cpp(NumericVector x, int n, double clevel = 0.95) {
                NumericVector medians(n);
                int size_x = x.size();
                // repeat sampling n times
                for (int i = 0; i < n; i++) {
                   // sample() function is also in sugar!!
                   // with identical syntax as in R:
                   // sample(Vector x, int size, replace = false)
                   NumericVector bsample_x = sample(x, size_x, true);
                   // each time save the median of the sample
                   // median() function is also in sugar
                   medians[i] = median(na_omit(bsample_x));
                }
                // calculate the quantiles in a simplified way
                // using sugar functions 
                int lower = ceil(n * (1 - clevel)/2);
                int upper = floor(n * (1 - (1 - clevel)/2));
                // If we provide the list of values when 
                // creating a new vector ::create is used
                IntegerVector idx = IntegerVector::create(lower, upper);
                // sorting a numeric vector in place
                // https://gallery.rcpp.org/articles/sorting/
                std::sort(medians.begin(), medians.end());
                NumericVector ci = medians[idx];

                return ci;
            }')

bootMedianCI_Cpp(x, 1000)


benchmark("bootR" = bootMedianCI_R(x, 1000),
          "bootCpp" = bootMedianCI_Cpp(x, 1000))[, 1:4]


# simulations using C++ are almost 50 times faster
# and the code is almost as easy in C++ as in R



#-------------------------------------------------------------------
# 2. Complex input/output objects


# R/C++ function may return just a single object

# However sometimes there is a need to return more 
# than just one element (object)

# The simplest solution in R is to put the objects together
# into a list - which can include objects of different types

#-----------------------------------------------------------------------
# return a list from C++ 

# Above we created a function colCVs that retunes
# CVs for each column - lets write a function that will return
# not a single vector of CVs, but also particular components
# (i.e. means and SDs) for comparison - in a form of a list

# R

colCVsR_list <- function(x) {
  n = nrow(x)
  means_x = colMeans(x)
  means_x2 = colMeans(x**2)
  
  sds = sqrt(n/(n-1) * (means_x2 - means_x**2))
  
  CVs = 100 * sds/means_x
  
  return(list("means" = means_x,
              "sds" = sds,
              "cvs" = CVs))
}

# recreate matrix m if needed

set.seed(987654321)

m <- matrix(rnorm(5e5),
            ncol = 10)

colCVsR_list(m)

colCVsR_list(m)$sds

# the C++ equivalent is in the file "functions/colCVsCpp_list.cpp"

# lets look inside and compile this source code

sourceCpp("functions/colCVsCpp_list.cpp")

colCVsCpp_list(m)

colCVsCpp_list(m)$sds


# lets compare the results

identical(colCVsR_list(m),
          colCVsCpp_list(m))

# each element of the list has to be compared separately

colCVsR_list(m)$means - colCVsCpp_list(m)$means
colCVsR_list(m)$sds - colCVsCpp_list(m)$sds
colCVsR_list(m)$cvs - colCVsCpp_list(m)$cvs

# differences are very small

#-----------------------------------------------------------------------
# return a data frame from C++ 

# as each of the returned elements has the same length 
# we may decide to return a data.frame instead of a list

# R

colCVsR_df <- function(x) {
  n = nrow(x)
  means_x = colMeans(x)
  means_x2 = colMeans(x**2)
  
  sds = sqrt(n/(n-1) * (means_x2 - means_x**2))
  
  CVs = 100 * sds/means_x
  
  return(data.frame("means" = means_x,
                    "sds" = sds,
                    "cvs" = CVs))
}

colCVsR_df(m)


# C++

# In Rcpp there is an object DataFrame defined
# which can be created with DataFrame::create()
# One can also use Named() or _[] to specify column names.

# the C++ equivalent is in the file "functions/colCVsCpp_df.cpp"

sourceCpp("functions/colCVsCpp_df.cpp")

colCVsCpp_df(m)

# now all columns can be easily compared

colCVsR_df(m) - colCVsCpp_df(m)

all(abs(colCVsR_df(m) - colCVsCpp_df(m)) < 1e-8)


# CAUTION !!
# When creating a DataFrame with DataFrame::create(), 
# the value of the original Vector element will not be 
# duplicated in the columns of the DataFrame. Instead
# the columns will be the REFERENCE to the original vector. 

# In such case changing the value in the original vector
# will also CHANGE the value in the DataFrame.
# To avoid this, use the clone() function which duplicates
# the values from the vector when creating a DataFrame column.

# to see the example check the file
# "functions/colCVsCpp_df2.cpp"

sourceCpp("functions/colCVsCpp_df2.cpp")

colCVsCpp_df2(m)



#-----------------------------------------------------------------------
# List as an input to C++ function

# lets remind the mapeR/Cpp() function
# and assume we want to assess the quality 
# of the linear model based on the result of 
# lm() function.
# Apart from MAPE lets also use other measures

# lets use the mtcars data as an example 

str(mtcars)

model_lm <- lm(mpg ~ ., 
               data = mtcars)

str(model_lm)

class(model_lm)

# lm result is a S3 class which
# in fact is a list

# we have all required elements

# real values
model_lm$model$mpg

# fitted values (predictions in the training sample)
model_lm$fitted.values

# and also residuals - their difference (r - p)
model_lm$residuals


all.equal(model_lm$residuals,
          model_lm$model$mpg - model_lm$fitted.values)


# Lets write the R function that operates on real 
# and forecasted values. To avoid checking the name 
# of the outcome variable in the model formula we 
# can calculate real as: real = fitted.values + residuals 

lmFitMetricsR <- function(model_lm) {
  
  # Lets check if input is an object of class lm(),
  # if not - stop and print an appropriate message
  if (class(model_lm) != "lm") 
    stop("The argument must be an lm() model result.")
  
  forecast = model_lm[["fitted.values"]]
  real = forecast + model_lm[["residuals"]]
  # for efficiency lets also store abs(resid)
  # which is used in many formulas
  absresid = abs(real - forecast)
  
  # Mean Square Error
  MSE <- mean(absresid^2)
  # Root Mean Square Error
  RMSE <- sqrt(MSE)
  # Mean Absolute Error
  MAE <- mean(absresid)
  # Mean Absolute Percentage Error
  MAPE <- mean(absresid/real)
  # Adjusted Mean Absolute Percentage Error
  AMAPE <- mean(absresid/(real+forecast))
  # Median Absolute Error
  MedAE <- median(absresid)
  # Mean Logarithmic Absolute Error
  MLAE <- mean((log(1 + real) - log(1 + forecast))^2)
  # Total Sum of Squares
  TSS <- sum((real - mean(real))^2)
  # Explained Sum of Squares
  RSS <- sum((forecast - real)^2)
  # R2
  R2 <- 1 - RSS/TSS
  
  result <- data.frame(MSE, RMSE, MAE, MAPE, 
                       AMAPE, MedAE, MLAE, R2)
  return(result)
}

# check how it works

lmFitMetricsR(model_lm)

lmFitMetricsR(m)

# and compare C++ variant, which is
# in the file "functions/lmFitMetricsCpp.cpp"

sourceCpp("functions/lmFitMetricsCpp.cpp")

# lets check how it works

lmFitMetricsCpp(model_lm)

lmFitMetricsCpp(m)

# compare R and C++ results

all.equal(lmFitMetricsR(model_lm),
          lmFitMetricsCpp(model_lm))

lmFitMetricsR(model_lm) - lmFitMetricsCpp(model_lm)

# CAUTION!
# As with the DataFrame creation, assigning 
# a DataFrame column to vector does not
# copy the column value to vector object, 
# but it will be a “reference” to the column. 
# When the values of vector object are changed,
# the content of the column will also be changed.

# Again, to create a vector by copying the 
# values from the column, clone() function 
# should be used.

# In Rcpp, DataFrame is in fact implemented
# as a vector of vectors. That is why DataFrame 
# has many member functions common to vector, e.g.:
# length(), size() - number of columns
# nrows() - Returns the number of rows
# names()
# fill(v) - fills all the columns of this DataFrame withVector v.
# push_back(v) - add a vector v to the end of the DataFrame
# push_front(x) - add a vector v at the beginning of the DataFrame
# and many others




#-----------------------------------------------------
# Exercises 9.


# Exercise 9.1
# Write an R and two variants of C++ function 
# (without and with sugar approach):
# rootCpp(x, n) that will
# calculate the root of order n (integer) from the value
# of x (double) - hint: use the C++ function pow(x, n) 
# Let the default value of n be 2.
# Apply the function(s) to sample values and compare 
# their results and efficiency.




# Exercise 9.2
# Write a version of colCVsCpp() handling missing values 
# using Rcpp sugar




# Exercise 9.3
# Using Rcpp sugar write a function any_naCpp(v)
# returning a logical value "true" if a numeric 
# vector (the only input) contains any missings
# and "false" otherwise.




# Exercise 9.4
# Write a cpp function basicStatsCpp(df) that based 
# on a data frame calculates for each column 
# (assuming for simplicity that each column is numeric)
# basic statistical measures:
# min, mean, median, n_nonmiss, max, sd, range
# and returns them as a list or a data.frame



