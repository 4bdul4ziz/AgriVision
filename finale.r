library(shiny)
library(reticulate)
library(png)

# Activate the Python environment
use_python("/usr/bin/python3")

# Define the paths to the Python scripts
map_path <- "map.py"
migrate_path <- "migrate.py"
agri_path <- "agri.py"

# Define the UI
ui <- fluidPage(
  titlePanel("AgriVision"),
  sidebarLayout(
    sidebarPanel(
      actionButton("open_maps", "Open Maps"),
      br(),
      actionButton("migrate_screenshots", "Migrate Screenshots"),
      br(),
      actionButton("calculate_area", "Calculate Area"),
      br(),
      actionButton("clear_images", "Clear Images")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Mask", plotOutput("mask_plot")),
        tabPanel("Original", plotOutput("original_plot")),
        tabPanel("Result", plotOutput("res_plot"))
      )
    )
  )
)

# Define the server
server <- function(input, output) {
  
  # Function to run a Python script
  run_python_script <- function(script_path) {
    py_run_file(script_path, convert = TRUE)
  }
  
  # Function to plot an image
  plot_image <- function(image_path) {
    img <- readPNG(image_path)
    plot(0, 0, type = "n", xlim = c(0, ncol(img)), ylim = c(0, nrow(img)),
         xlab = "", ylab = "")
    rasterImage(img, 0, 0, ncol(img), nrow(img))
  }
  
  # Open Maps button
  observeEvent(input$open_maps, {
    run_python_script(map_path)
  })
  
  # Migrate Screenshots button
  observeEvent(input$migrate_screenshots, {
    run_python_script(migrate_path)
  })
  
  # Calculate Area button
  observeEvent(input$calculate_area, {
    run_python_script(agri_path)
    output$mask_plot <- renderPlot({ plot_image("mask.png") })
    output$original_plot <- renderPlot({ plot_image("original.png") })
    output$res_plot <- renderPlot({ plot_image("result.png") })
  })
  
  # Clear Images button
  observeEvent(input$clear_images, {
    file.remove("/Users/abdul/Desktop/Programming/AgriVision/images/*")
    output$mask_plot <- renderPlot(NULL)
    output$original_plot <- renderPlot(NULL)
    output$res_plot <- renderPlot(NULL)
  })
  output$green_area <- renderText("")
  
}

# Run the app
shinyApp(ui = ui, server = server)
