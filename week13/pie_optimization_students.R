# reactive elements are built in zone two. Figure out how exactly reactive works
# 

ui <- fluidPage(
  titlePanel("Choose type of chart with radio buttons widget"),
  sidebarLayout(
    sidebarPanel(
      radioButtons("type", "Type of chart:", choices = c("Bar", "Pie")),
      textInput("title", "Title of chart:")
    ),
    mainPanel(
      plotOutput("plt")
    )
  )
)

library(tidyverse)

data <- readRDS("./gumtree_en.rds")
plt <- data %>%
  count(rooms) %>%
  mutate(per = round(n / sum(n) * 100)) %>%
  arrange(desc(rooms)) %>%
  ggplot(aes("", per, fill = rooms)) +
  geom_bar(stat = "identity") +
  scale_fill_discrete(name = "Number of rooms [-]") +
  xlab("") +
  ylab("Share of offers [%]") +
  theme(plot.title = element_text(size = 30, hjust = 0.5))

server <- function(input, output, session) {
  re <- reactive({input$title})
  output$plt <- renderPlot({
    Sys.sleep(2)
    plt + re()
      
    if (input$type == "Pie") {
      plt <- plt +
        coord_polar("y") +
        geom_text(aes(x = 1, y = cumsum(per) - per / 2,
                      label = str_c(per, "%")))
    }
    
    plt
  })
}

library(shiny)


shinyApp(ui, server)