library(readr)
library(dplyr)
library(ggplot2)

FAOSTAT_data_4_30_2022 <- read_csv("FAO_shiny/FAOSTAT_data_4-30-2022.csv")
summary(FAOSTAT_data_4_30_2022)

fao_data_small <- select(FAOSTAT_data_4_30_2022, 
                         c(Area,Element, Item, Year, Unit, Value))
head(fao_data_small)
summary(fao_data_small)

products <- unique(fao_data_small[c("Item")])
products

countries <- unique(fao_data_small[c("Area")])
countries

elements <- unique(fao_data_small[c("Element")])

ggplot2(data = (filter(fao_data_small, 
                Element == "Producing Animals/Slaughtered", 
                Year == 2018)),
        aes,
        )


plot(fao_data_small$)