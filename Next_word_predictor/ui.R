#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)

library(markdown)
library(dplyr)


# Define UI for application that draws a histogram
shinyUI(fluidPage(

    navbarPage("Next Word Predictor",
               theme = shinytheme("spacelab"),
               tabPanel("Home",
                        fillRow(height="100px",column(12,numericInput(
                          "n",
                          "Maximum number of candidate words to show:",
                          1,
                          min = 1,
                          max = 50))),
                        fillRow(height="60px",column(12,textInput("userInput",
                                         "Type a phrase:",
                                         value =  "",
                                         placeholder = "Enter text here"))),
                        fillRow(column(12, br(),br(),
                                 h4("Candidate words:"),
                                 textOutput("prediction1"))
                        )),
               tabPanel("About",
                        br(),
                        div("Next Word Predictor predicts the next word(s)
                            based on text entered by a user.",
                            br(),
                            br(),
                            "Start by selecting the maximum number of candidate words you wish to see, 
                            start to type some text. then The predicted next word will be shown when the app
                            detects that you have finished typing one or more
                            words. When entering text, please allow a few
                            seconds for the output to appear.",
                            br(),
                            br(),
                            "The source code for this application can be found
                            on GitHub:",
                            br(),
                            br(),
                            img(src = "github.png"),
                            a(target = "_blank", href = "https://github.com/ArnulfoPerez/wordpredictor",
                              "Next Word Predictor repository")),
                        
                        br(),
                        h3("Contact info"),
                        br(),
                        div(
                            br(),
                            img(src = "linkedin.png"),
                            a(target = "_blank", href="https://www.linkedin.com/in/arnulfoperez/", "Arnulfo Perez"),
                            br(),
                            img(src = "twitter.png"),
                            a(target = "_blank", href="https://twitter.com/arpez/", "arpez"))
               )
    )
               
        )
    )
