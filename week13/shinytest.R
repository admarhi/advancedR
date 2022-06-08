library(shiny)

ui <- fluidPage(
  titlePanel("Choose input"),
  sidebarLayout(
    sidebarPanel(
      selectInput(x, "xaxis", choices = ),
      selectInput(y, "yaxis", choices = )
    ),
    mainPanel(
      plotOutput("plt")
    )
  )
)

data <- iris

server <- function(input, output, session) {
  lm(formula = y ~ x, data = data)
}

shinyApp(ui, server)