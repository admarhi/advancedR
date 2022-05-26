# zone 1
library(tidyverse)

data <- readRDS("data/gumtree_en.rds") %>% 
  filter(price <= 5000)

ui <- fluidPage(
  titlePanel("Rental price distribution of apartments with given footage"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("sqrt_m2", HTML("Footage interval:"),
                  min = 20, max = 200, value = c(50, 80), step = 10)
    ),
    mainPanel(
      plotOutput("plt"),
      textOutput("obs"),
      textOutput("avg")
    )
  )
)


# # wrong we need to move something from zone 3 to zone 2?

server <- function(input, output, session) {

  # zone 2 for now is empty

  output$plt <- renderPlot({
    # zone 3
    data %>%
      filter(
        between(footage, input$sqrt_m2[1], input$sqrt_m2[2])) %>%
      ggplot(aes(price)) +
      geom_histogram() +
      xlab(expression("Price [PLN]")) +
      ylab("Amount of offers [-]")
  })
  output$obs <- renderText({
    # zone 3
    data %>%
      filter(
        between(footage, input$sqrt_m2[1], input$sqrt_m2[2])) %>%
      summarise(obs = n()) %>%
      pull(obs) %>%
      paste("Amount of offers:", .)
  })

  output$avg <- renderText({
    # zone 3
    data %>%
      filter(
        between(footage, input$sqrt_m2[1], input$sqrt_m2[2])) %>%
      summarise(avg = round(mean(price, na.rm  = TRUE), 2)) %>%
      pull(avg) %>%
      paste("Amount of offers:", .)
  })
}



shinyApp(ui, server)


