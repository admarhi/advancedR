install.packages(shiny)
library(shiny)
library(ggplot2)

ui <- fluidPage(
  pageWithSidebar(
    headerPanel('Iris k-means clustering'),
    sidebarPanel(
      selectInput(inputId = 'xcol', 
                  label = 'X Variable', 
                  choices = names(iris)),
      selectInput(inputId = 'ycol', 
                  label = 'Y Variable', 
                  choices = names(iris),
                  selected = names(iris)[[2]]),
    ),
    mainPanel(
      #plotOutput('plot1'),
      #plotOutput('plot2')
      DT::dataTableOutput('mytable')
    )
  )
)


library(tidyverse)

data <- readRDS("gumtree.rds") %>% select(-opis)

server <- function(input, output, session) {
  
  # Combine the selected variables into a new data frame
  # selectedData <- reactive({
  #  iris[, c(input$xcol, input$ycol)]
  # })
  
  # x <- as.numeric(reactive(input$xcol))
  # output$plot1 <- renderDataTable({hist(x)})
  
  output$mytable <- DT::renderDataTable(head(selectedData)) 
  # clusters <- reactive({
  #  kmeans(selectedData(), input$clusters)
  # })
  # output$plot1 <- renderPlot({
  #  palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
  #            "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
    
  #  par(mar = c(5.1, 4.1, 0, 1))
  #  plot(selectedData(),
  #       col = clusters()$cluster,
  #       pch = 20, cex = 3)
  #  points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  # })
}
  

shinyApp(ui, server)

