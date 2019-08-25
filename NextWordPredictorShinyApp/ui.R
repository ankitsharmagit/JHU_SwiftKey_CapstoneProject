#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css")
        
    ),
    img(src='Swiftkeylogo.png', align = "right"),
    # Application title
    titlePanel("Next Word Predictor"),
    h4("John Hopkins University / SwiftKey Data Science Capstone", style="color:gray"),
    h5("Submitted by Ankit Sharma", style="color:gray"),
    
    hr(),

    # Input box 
    
    sidebarLayout(
        
        sidebarPanel(
            
            h3("Please enter an incomplete sentence"),
            textInput("inputtext", label = "", value = "type"),
            helpText("Type in a sentence above and the prediction for the next word will display to the right."),
            
            hr()
        ),

        # Display/Predict the next word to be entered
        mainPanel(
            tabsetPanel(
                tabPanel(
                    "Prediction",
                    h4("The predicted word (with highest probability) is:"),
                    HTML("<span style='color:red'>"),
                    h3(textOutput("predictedWordMain"), align="center"),
                    HTML("</span>"),
                    br(),
                    div(dataTableOutput("bestwordtable"), style='font-size:150%')        
                ),
                tabPanel("App documentation",
                         includeMarkdown("documentation.Rmd")
                )
            )
        ) #mainPanel ends
    )
))
