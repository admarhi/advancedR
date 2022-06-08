library(ggplot2)
data(diamonds)
head(diamonds)

# 2. Use split() and interaction function to split diamonds 
# dataset with respect to two categorical variables: color and cut.

data.list <- split(diamonds, interaction(diamonds$cut, diamonds$color))
data.list

# 3. Your task is to rewrite the following loop in a form of lapply

FUN = function(x) {
  hist(summary(lm(price ~ carat, data = data.list[[i]]))$residuals,
       main = paste0(names(data.list)[[i]]))
}

lapply(data.list, FUN)
