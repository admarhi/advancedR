# They report whether any or all of their arguments are TRUE 
# https://www.oreilly.com/library/view/the-art-of/9781593273842/ch02s05.html
x <- 1:10
 
any(x >8)

c(x[1]>8 | x[2]>8 | x[3]>8 | x[4]>8 | x[5]>8 | x[6]>8 | x[7]>8 | x[8]>8
  | x[9]>8 | x[10]>8)


any(x > 88)

c(x[1]>88 | x[2]>88 | x[3]>88 | x[4]>88 | x[5]>88 | x[6]>88 | x[7]>88 | x[8]>88
  | x[9]>88 | x[10]>88)

################################################################################
# Given a set of logical vectors, are all of the values true?

all(x  <88)

c(x[1]<88 & x[2]<88 & x[3]<88 & x[4]<88 & x[5]<88 & x[6]<88 & x[7]<88 & x[8]<88
  & x[9]<88 & x[10]<88)


all(x > 0)


c(x[1]>0 & x[2]>0 & x[3]>0 & x[4]>0 & x[5]>0 & x[6]>0 & x[7]>0 & x[8]>0
  & x[9]>0 & x[10]>0)


###### using loops 
x <- 1:10

check<-c()
for (i in 1:length(x)) {
  
  add<-x[i]>
  
  check<-rbind(check,add)
  
}


first<-check[1]
for (i in 2:length(check)) {
  
  first <- c(first | check[i])
  
}

first

all(x > 0)



