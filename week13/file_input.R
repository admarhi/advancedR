ui <- fluidPage(
  titlePanel("fileInput"),
  sidebarLayout(
    sidebarPanel(
      fileInput(
        inputId = "fil",
        label = "Choose file from disk:",
        multiple = TRUE,
        accept = c(".csv", ".txt"),
        width = "300px",
        buttonLabel = icon("folder"),
        placeholder = "Search..."
      )
    ),
    mainPanel(tableOutput("tbl"))
  )
)


server <- function(input, output, session) {
  output$tbl <- renderTable({
    if (is.null(input$fil)) {
      return(NULL)
    }
    
    vec <- unlist(input$fil)
    
    tibble(key = names(vec), value = vec)
  })
}

shinyApp(ui, server)
