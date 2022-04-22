m <- matrix(1:6, nrow=2, byrow=TRUE)

m
collaps_input <- function(x) paste(x, collapse = ":")

apply(m, 1, collaps_input) #  row

apply(m, 2, collaps_input) # column 

apply(m, c(1, 2), collaps_input)


#########################################
apply(m, 2, collaps_input)
list_1<-c()
for (i in 1:ncol(m)) {
  # print(collaps_input(m[,i]))
  list_1<-cbind(list_1, collaps_input(m[,i]))
}

list_1
apply(m, 2, collaps_input)
#########################################


list_1<-c()
for (i in 1:nrow(m)) {
  print(collaps_input(m[i,]))
  list_1<-cbind(list_1, collaps_input(m[,i]))
}
apply(m, 1, collaps_input)

##########################################
m <- matrix(1:6, nrow=2, byrow=TRUE)

all<- matrix(0, nrow=2, ncol =3 ,byrow=TRUE)
for (i in 1:nrow(m)) {
  for (j in 1:ncol(m)) {
    all[i,j]<-collaps_input(m[i,j])
  }

}
all
apply(m, c(1, 2), collaps_input)

##########################################







