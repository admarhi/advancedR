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

data2 <- read_csv("FAO_shiny/prod_ind/Production_Indices_E_All_Data.csv")
head(data2)
data3 <- read_csv("FAO_shiny/prod_ind/FAOSTAT_data_6-8-2022.csv")
head(data3)
data4 <- read_csv("FAO_shiny/prod_ind/FAOSTAT_data_6-8-2022-2.csv")
head(data4)
data5 <- read_csv("FAO_shiny/prod_ind/Production_Crops_Livestock_E_All_Data.csv")
head(data4)
data6 <- data5[-c(1,3,5,seq(7, ncol(data5), 2))]
products2 <- unique(data6[c("Item")])
data7 <- subset(data6, data6$Element != "Area harvested")
data8 <- subset(data7, data7$Item == c("Cattle","Chickens","Goats","Horses","Sheep","Ducks","Pigs"))

library(plotly)
fig <- get_figure("manfredini", 63)


for (i in unique(data8$Item)) {
  subset(data8, data8$Item == i) %>% plot()
}
