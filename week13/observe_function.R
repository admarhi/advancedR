data <- readRDS("C:/Users/ewawe/Desktop/shiny_2/10/data/gumtree_en.rds") %>%
  filter(between(price, 0, 10^4), between(footage, 0, 10^2))

ui <- fluidPage(
  titlePanel("Data exploration"),
  sidebarLayout(
    sidebarPanel(
      selectInput("columns", "Choose columns of csv:", choices = colnames(data), multiple = TRUE),
      actionButton("save", "Save to file")
    ),
    mainPanel(DT::dataTableOutput("tab"))
  )
)

library(DT)
library(tidyverse)

Sys.setlocale(category = "LC_ALL", locale = "Polish")

data <- readRDS("C:/Users/ewawe/Desktop/shiny_2/10/data/gumtree_en.rds") %>%
  filter(between(price, 0, 10^4), between(footage, 0, 10^2))

opts <- list(
  language = list(url = "//cdn.datatables.net/plug-ins/1.10.19/i18n/Polish.json"),
  pageLength = 30,
  searchHighlight = TRUE,
  columnDefs = list(list(targets = c(1, 10), searchable = FALSE))
)

server <- function(input, output, session) {
  output$tab <- DT::renderDataTable({
    data %>% select(-description)
  }, options = opts, selection = 'single') # interactive functionality of DT package - choose and capture single row by clicking
  
  observe({
    input$save
    isolate(
      if (!is.null(input$tab_rows_selected) & !is.null(input$columns)) {
        write.csv(data[input$tab_rows_selected, input$columns], file = "offer.csv")
      }
    )
  })
}



shinyApp(ui, server)