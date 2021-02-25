library(shiny)
library(ggplot2)
library(tidyverse)
library(shinyjs)
library(bslib)
library(thematic)
library(plotly)


theme_set(theme_minimal())

ui <- fluidPage(
    
    theme = bs_theme(bg = "#444444", fg = "#E4E4E4", primary = "#E39777",
                     base_font = list(font_google("Prompt", local = FALSE), "Roboto", "sans-serif"),
                     "font-size-base" = "0.75rem"),
    
    # titlePanel("Time to Herd Immunity & Vaccination COVID-19 CHILE"),

    
    br(),
    
        fluidRow(
            column(12, align = "center",
                   h1("Days until 70% of the population is vaccinated against COVID-19 in "),
                   # h4(countupOutput("cnt")),
                   uiOutput('moreControls'),
                   br(),
                      
                      
                      fluidRow(
                       column(4, align = "left",
                              h3("Inputs"),
                              br(),
                              useShinyjs(),
                              selectInput("dose", "Dose", choices = ""),
                              selectInput("regSelection", "Region", multiple = T, choices = "v1"),

                              div(style="display:inline-block; margin-right: -120px;", radioButtons(inputId = "newDailyVac", label = "Vaccination", choices = "")),
                              div(style="display:inline-block;", tags$span(id = "sp1_ma", "Rolling")),
                              div(style="display:inline-block; margin-top:0px;", numericInput(inputId = "numRol", width = 70, value = 7, label = "", min = 1)),
                              div(style="display:inline-block;", tags$span(id = "sp2_ma","days")),

                              checkboxInput("normData", "Normalize by population", value = FALSE, width = NULL),
                        
                       ),
                       column(width = 8, align = "left",
                              h3("Chart"),
                              br(),
                              plotlyOutput("myPlot")
                       )
                      )
            )
        ),
    hr(),
    tags$a(href="https://twitter.com/lluta", icon("twitter"), style="text-align:center")
)
  
    
    
    
#     fluidRow(
#         column(12,
#                fluidRow(
#                    column(6,
#                           fluidRow(12,
#                           h3("Inputs"),
#                           br(),
#                           useShinyjs(),
#                           selectInput("dose", "Dose", choices = ""),
#                           selectInput("regSelection", "Region", multiple = T, choices = "v1"),
#                            
#                            div(style="display:inline-block; margin-right: -100px;", radioButtons(inputId = "newDailyVac", label = "Vaccination", choices = "")),
#                            div(style="display:inline-block;", tags$span(id = "sp1_ma", "Rolling")),
#                            div(style="display:inline-block; margin-top:0px;", numericInput(inputId = "numRol", width = 70, value = 7, label = "", min = 1)),
#                            div(style="display:inline-block;", tags$span(id = "sp2_ma","days")),
#                            
#                            checkboxInput("normData", "Normalize by population", value = FALSE, width = NULL)
#                            )
#                           ),
#                    
#                    fluidRow(12,
#                           h3("Charts"),
#                           br(),
#                           plotlyOutput("myPlot")
#                    ),
#                    
#                    column(6,
#                           h3("Days to Herd"),
#                           br(),
#                           h4(countupOutput("cnt"))
#                    )
#                )
#         )
#     )
# )


# 
#     titlePanel("Time to Herd & Vaccination"),
#     useShinyjs(),
#     selectInput("dose", "Dose", choices = ""),
#     selectInput("regSelection", "Region", multiple = T, choices = "v1"),
#     
#     div(style="display:inline-block; margin-right: -100px;", radioButtons(inputId = "newDailyVac", label = "Vaccination", choices = "")),
#     div(style="display:inline-block;", tags$span(id = "sp1_ma", "Rolling")),
#     div(style="display:inline-block; margin-top:0px;", numericInput(inputId = "numRol", width = 70, value = 7, label = "", min = 1)),
#     div(style="display:inline-block;", tags$span(id = "sp2_ma","days")),
#     
#     checkboxInput("normData", "Normalize by population", value = FALSE, width = NULL),
#     
#     plotOutput("myPlot")