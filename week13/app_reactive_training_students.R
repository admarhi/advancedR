library(tidyverse)

data <- readRDS("C:/Users/ewawe/Desktop/shiny_2/10/data/gumtree_en.rds")

server <- function(input, output, session) {
  output$plt <- renderPlot({
    Sys.sleep(2)
    plt <- data %>%
      count(rooms) %>%
      mutate(per = round(n / sum(n) * 100)) %>%
      arrange(desc(rooms)) %>%
      ggplot(aes("", per, fill = rooms)) +
      geom_bar(stat = "identity") +
      scale_fill_discrete(name = "Number of rooms [-]") +
      xlab("") +
      ylab("Share of offers [%]") +
      ggtitle(input$title) +
      theme(plot.title = element_text(size = 30, hjust = 0.5))
    
    if (input$type == "Pie") {
      plt <- plt +
        coord_polar("y") +
        geom_text(aes(x = 1, y = cumsum(per) - per / 2,
                      label = str_c(per, "%")))
    }
    
    plt
  })
}