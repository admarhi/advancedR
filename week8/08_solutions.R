##########################################################
# Exercises 8

# Exercise 8.1.
# For each function included in the file "Exercise1_functionsC.cpp":
# - try to recognize what are the equivalents of the following 
#   functions in base R
# - compare their time efficiency with base R functions
#  (Do not worry if you do not understand all the elements of the code)

sourceCpp("Exercise1_functionsC.cpp")

f1(2)
f1(c(2,2,2))
f1(c(2,4,6))
f1(c(2,4,6,8))

#equivalent - mean

benchmark("R" = mean(rnorm(100)),
          "C" = f1(rnorm(100)),
          replications = 50000
)

#   test replications elapsed relative user.self sys.self user.child sys.child
# 2    C        50000    0.59    1.000      0.58        0         NA        NA
# 1    R        50000    0.63    1.068      0.63        0         NA        NA


f2(2)
f2(c(2,4))
f2(c(2,4,6))

#equivalent - cumsum 

cumsum(c(2,4,6))

benchmark("R" = cumsum(rnorm(100)),
          "C" = f2(rnorm(100)),
          replications = 50000
)

#   test replications elapsed relative user.self sys.self user.child sys.child
# 2    C        50000    0.61    1.271      0.61     0.00         NA        NA
# 1    R        50000    0.48    1.000      0.46     0.02         NA        NA

f3(T)

f3(c(F,T))

f3(c(T, T, T))

f3(c(F, F, F))

# equivalent - any 

any(T)

any(c(F,T))

any(c(T, T, T))

any(c(F, F, F))



g <- ifelse(rnorm(100)>0.50, TRUE, FALSE)

benchmark("R" = any(g),
          "C" = f3(g),
          replications = 50000
)

#   test replications elapsed relative user.self sys.self user.child sys.child
# 2    C        50000    0.17    1.545      0.17        0         NA        NA
# 1    R        50000    0.11    1.000      0.10        0         NA        NA



# Exercise 8.2.
# Convert the following R functions into equivalents written in C++.
# For simplicity, you can assume that the input data does not contain
# missing values.
# - min()
# - cummax().
# - range()

#min

cppFunction('double minC(NumericVector x) {
  int n = x.size();
  double out = x[0];
  
  for (int i = 0; i < n; i++) {
    out = std::min(out, x[i]);
  }
  
  return out;
}')


#cummax

cppFunction('NumericVector cummaxC(NumericVector x) {
  int n = x.size();
  NumericVector out(n);

  out[0] = x[0];
  for (int i = 1; i < n; ++i) {
    out[i]  = std::max(out[i - 1], x[i]);
  }
  return out;
}')


#range

cppFunction('NumericVector rangeC(NumericVector x) {
  double omin = x[0], omax = x[0];
  int n = x.size();
  
  if (n == 0) stop("`length(x)` must be greater than 0.");
  
  for (int i = 1; i < n; i++) {
    omin = std::min(x[i], omin);
    omax = std::max(x[i], omax);
  }
  
  NumericVector out(2);
  out[0] = omin;
  out[1] = omax;
  return out;
}')


# Exercise 8.3.
# Write functions in R and C++ that calculate:
# - kurtosis based on the value vector: 
#   https://en.wikipedia.org/wiki/Kurtosis
# - factorial based on an argument being a natural number
#   https://en.wikipedia.org/wiki/Factorial


