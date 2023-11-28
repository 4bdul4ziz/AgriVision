library(shiny)
library(reticulate)
library(png)

# Activate the Python environment
use_python("~/miniconda3/envs/r-reticulate/bin/python")

# Define the paths to the Python scripts
map_path <- "map.py"
migrate_path <- "migrate.py"
agri_path <- "agri.py"
clear_path <- "clear.py"
weather_api <- "weatherapi.py"

# Define the UI
ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      /* Custom CSS to style the UI */
      .btn-primary {
        background-color: #5cb85c;
        border-color: #4cae4c;
      }
      .btn-primary:hover {
        background-color: #449d44;
        border-color: #398439;
      }
      .btn-primary:active, .btn-primary.active {
        background-color: #449d44;
        border-color: #398439;
      }
      .nav-tabs > li > a:hover {
        border-color: #5cb85c;
      }
      .nav-tabs > li.active > a, .nav-tabs > li.active > a:hover, .nav-tabs > li.active > a:focus {
        background-color: #5cb85c;
        border-color: #5cb85c;
      }
      .nav-tabs > li > a {
        color: #5cb85c;
      }
      .navbar-default {
        background-color: #f5f5f5;
        border-color: #e7e7e7;
      }
      .navbar-default .navbar-nav > li > a:hover, .navbar-default .navbar-nav > li > a:focus {
        background-color: #e7e7e7;
      }
      .navbar-default .navbar-brand {
        color: #5cb85c;
      }
    "))
  ),
  navbarPage(
    "AgriVision",
    tabPanel(
      "Calculate Green Area",
      textInput("loc", "Enter location"),
      dateInput("date_pred", "Enter date for prediction"),
      sidebarLayout(
        sidebarPanel(
          actionButton("open_maps", "Open Maps"),
          br(),
          actionButton("migrate_screenshots", "Migrate Screenshots"),
          br(),
          actionButton("calculate_area", "Calculate Green Area", class = "btn-primary"),
          br(),
          actionButton("clear_images", "Clear Images"),
          br(),
          actionButton("clear_graph", "Clear Plots", class = "btn-danger"),
          br(),
          actionButton("run_api", "Find details"),

        ),
        mainPanel(
          tabsetPanel(
            tabPanel("Mask", plotOutput("mask_plot")),
            tabPanel("Original", plotOutput("original_plot")),
            tabPanel("Result", plotOutput("res_plot")),
            tabPanel("Location",textOutput("Location_output")),
            tabPanel("Attributes",textOutput("Attributes_output"))
          )
        )
      )
    ),
   
    tabPanel(
      "About",
      tags$div(
        style = "padding: 20px;",
        tags$h3("AgriVision"),
        tags$p(
          "AgriVision is a tool designed to calculate the green cultivatable land in a satellite image  using Python and R."
        ),
        tags$p(
          "The tool consists of several Python scripts that use OpenCV to preprocess and analyze the image, and R Shiny for the user interface."
        ),
        tags$p(
          "This tool was created as part of a project for the Summer Research Internship at VIT Chennai."
        ),
        tags$p(
          "Developed by Abdul Aziz A.B and Aman Gupta."
        )
      )
    )
  )
)
source_python('weatherapi.py')

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
  
  #to show location details
  output$Location_output <- renderText({

    if (file.size("data/location.txt")>0){

    Location_file_read <- read.delim("data/location.txt", header = TRUE, sep = "\n") # nolint

    paste(toString(Location_file_read))
    }
  })

  #to show climate attributes
  output$Attributes_output <- renderText({

    if (file.size("data/attributes.txt")>0){

    Attribute_file_read <- read.delim("data/attributes.txt", header = TRUE, sep = "\n") # nolint

    paste(toString(Attribute_file_read))
    }
  })

  #run weather api button
  observeEvent(input$run_api, {
    value=input$loc
    date=input$date_pred
    v=test_weather(value,date)
    #run_python_script(weather_api) 
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
  
  observeEvent(input$clear_images, {
    # Get a list of all the files in the directory
    files <- list.files("working images")
    
    # Remove each file one by one
    for (file in files) {
      file.remove(paste0("working images", file))
    }
    
    # Clear the image plots
    output$mask_plot <- renderPlot(NULL)
    output$original_plot <- renderPlot(NULL)
    output$res_plot <- renderPlot(NULL)
  })

  observeEvent(input$clear_graph, {
    # Clear the image plots
    output$mask_plot <- renderPlot(NULL)
    output$original_plot <- renderPlot(NULL)
    output$res_plot <- renderPlot(NULL)
    run_python_script(clear_path)
  })
  
}
shinyApp(ui = ui, server = server)