# Library
library(shiny)


# 1. most efficient placement
# # A wrapper function for data import ()
# read_data <- function() {
#   data <- readRDS("C:/Users/ewawe/Desktop/shiny_2/shiny_class_2/data/gumtree_en.rds")
#   print("Importing dataset...")
#   data
# }
# 
# # --------------------------------------------
# 
# # Data Import
# Data <- read_data()

# User interface
ui <- fluidPage(
  mainPanel(
    actionButton("button", "Compute"), br(),
    "Average price of apartment:",
    textOutput("gumtree_table")
  )
)

# Server
server <- function(input, output, session) {
  
  # 2. less efficient palcement
  # A wrapper function for data import ()
  # read_data <- function() {
  #   data <- readRDS("C:/Users/ewawe/Desktop/shiny_2/shiny_class_2/data/gumtree_en.rds")
  #   print("Importing dataset...")
  #   data
  # }
  # 
  # Data <- read_data()
  
  output$gumtree_table <- renderText({
    
    # 3. the worst placement
    
    read_data <- function() {
      data <- readRDS("C:/Users/ewawe/Desktop/shiny_2/shiny_class_2/data/gumtree_en.rds")
      print("Importing dataset...")
      data
    }
    
    Data <- read_data()
    
    
    input$button
    mean(Data$price, na.rm = TRUE)
  })
}

shinyApp(ui, server)
