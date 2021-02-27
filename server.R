source("get_data.R")

#Load your data

server <- function(input, output, session) {
    
    df <- get_data()
    
    #Update the dose input
    updateSelectInput(session, "dose", choices = sort(unique(df$Dosis)), selected = "Primera")

    #Update the region list
    updateSelectInput(session, "regSelection",
                      choices = sort(unique(df$Region)), selected = "Chile")

    updateRadioButtons(session, "newDailyVac", choices = c("Cummulative", "New Daily Vaccination"))

    observe(
        if(input$newDailyVac == "New Daily Vaccination") {
            toggle("numRol")
            shinyjs::show("sp1_ma")
            shinyjs::show("sp2_ma")
        } else if (input$newDailyVac == "Cummulative") {
            toggle("numRol")
            toggle("sp1_ma")
            toggle("sp2_ma")
        }
    )

    observe(
        if (is.na(input$numRol)) {
            updateNumericInput(session, "numRol", value = "")
        } else if (is.character(input$numRol)) {
            updateNumericInput(session, "numRol", value = 7)
        } else if (input$numRol <= 0) {
            updateNumericInput(session, "numRol", value = 7)
        } else {
    
        }
    )
    
    # output$cnt <- renderCountup({
    #     countup(input$numRol, duration = 10, start = TRUE)
    # })
    
    
    
    output$moreControls <- renderUI({
        req(input$regSelection)
        lapply(1:length(input$regSelection), function(i) {
            h2(style="color: #d66638;", paste0(input$regSelection[i],
                      " is ",
                      round(timeToHerd(df, input$regSelection[i]), 0),
                      " days"),
            )
            })
    })

    
    # Calculate time to herd
    timeToHerd <- function(data, reg){
        # data %>% group_by(Region, Dosis) %>% 
        #     arrange(Fecha) %>% 
        #     mutate(daily = c(Cantidad[1], diff(Cantidad))) %>% 
        #     mutate(roll_mean = zoo::rollmean(daily, k = 7, fill = NA, align = "right")) %>% 
        #     mutate(herd = (Poblacion * 0.7 - Cantidad * 0.5) / (roll_mean * 0.5) ) %>% 
        #     filter(Region == reg, Dosis == "Primera") %>% 
        #     last() %>% 
        #     tail(1)
        
        data %>% 
            select(Region, Dosis, Fecha, Cantidad, Poblacion) %>% 
            spread(key = Dosis, value = Cantidad) %>% 
            group_by(Region) %>% arrange(Fecha) %>% 
            mutate(Total = Primera + Segunda) %>% 
            mutate(daily = c(Total[1], diff(Total))) %>%
            mutate(roll_mean = zoo::rollmean(daily, k = 7, fill = NA, align = "right")) %>% 
            mutate(herd = (Poblacion * 0.7 - Total * 0.5) / (roll_mean * 0.5) ) %>%
            filter(Region == reg) %>%
            last() %>%
            tail(1)
            
    }

    

    #Load the chart function
    draw_chart <- function(df, listr, do, vac, nor){
        # listr :: list of region selected
        # do    :: dose -> either primera or segunda
        # vac   :: either cummulative or rolling
        # nor   :: normalized by population
        
        if (nor){
            if (vac == "Cummulative"){
                df2 <- df %>%
                    filter(Region %in% listr, Dosis == do)
                
                ggplot(df2, aes(x = Fecha, y = Perc_Vacunado)) +
                    geom_line(aes(color = Region)) +
                    labs(title = "Percentage of population vaccinated",
                         x = "",
                         y = "") +
                    scale_y_continuous(labels = scales::comma) +
                    
                    theme(plot.background = element_rect(fill = "#444444"),
                          text = element_text(colour = "#D4D4D4"),
                          axis.text.x = element_text(colour = "#D4D4D4", margin = margin(t = 1000)),
                          axis.text.y = element_text(colour = "#D4D4D4"),
                          panel.border = element_blank()
                          
                    )
                
            } else {
                df2 <- df %>%
                    filter(Region %in% listr, Dosis == do)
                
                df2 <- df2 %>% group_by(Region, Dosis) %>%
                    arrange(Fecha) %>%
                    mutate(roll_mean = zoo::rollmean(daily, k = input$numRol, fill = NA, align = "right") * 100 / Poblacion) %>%
                    drop_na()
                
                p <- ggplot(df2, aes(x = Fecha, y = roll_mean)) +
                    geom_line(aes(color = Region)) +
                    labs(title = "Percentage of population receiving the vaccine daily",
                         x = "",
                         y = "") +
                    
                    theme(plot.background = element_rect(fill = "#444444"),
                          text = element_text(colour = "#D4D4D4"),
                          axis.text.x = element_text(colour = "#D4D4D4"),
                          axis.text.y = element_text(colour = "#D4D4D4"),
                          panel.border = element_blank()
                          
                    )
                
                ggplotly(p) %>% layout(title = list(text = paste0('Percentage of population receiving the vaccine daily',
                                                                  '<br>',
                                                                  '<sup>',
                                                                  input$numRol,
                                                                  '-day moving average',
                                                                  '</sup>')))
            }
            
        } else {
            if (vac == "Cummulative"){
                df2 <- df %>%
                    filter(Region %in% listr, Dosis == do)
                
                ggplot(df2, aes(x = Fecha, y = Cantidad)) +
                    geom_line(aes(color = Region)) +
                    
                    scale_y_continuous(labels = scales::comma) +
                labs(title = "Cummulative vaccine doses administered",
                     x = "",
                     y = "") +
                    
                    
                theme(plot.background = element_rect(fill = "#444444"),
                      text = element_text(colour = "#D4D4D4"),
                      axis.text.x = element_text(colour = "#D4D4D4"),
                      axis.text.y = element_text(colour = "#D4D4D4"),
                      panel.border = element_blank()
                      
                )
                
            } else {
                df2 <- df %>%
                    filter(Region %in% listr, Dosis == do)
                
                df2 <- df2 %>% group_by(Region, Dosis) %>%
                    arrange(Fecha) %>%
                    mutate(roll_mean = zoo::rollmean(daily, k = input$numRol, fill = NA, align = "right")) %>%
                    drop_na()
                
                p <- ggplot(df2, aes(x = Fecha, y = roll_mean)) +
                    geom_line(aes(color = Region)) +
                    labs(title = "Number of vaccine doses administered",
                         x = "",
                         y = "") +
                    
                    scale_y_continuous(labels = scales::comma) +
                    
                    theme(plot.background = element_rect(fill = "#444444"),
                          text = element_text(colour = "#D4D4D4"),
                          axis.text.x = element_text(colour = "#D4D4D4"),
                          axis.text.y = element_text(colour = "#D4D4D4"),
                          panel.border = element_blank()
                        
                    )
                        
                
                ggplotly(p) %>% layout(title = list(text = paste0('Number of vaccine doses administered daily',
                                                                  '<br>',
                                                                  '<sup>',
                                                                  input$numRol,
                                                                  '-day moving average',
                                                                  '</sup>')))
            }
            
        }

    }

    #Render the plot
    output$myPlot = renderPlotly({
        req(input$regSelection)
        if(!is.na(input$numRol) && input$numRol != "") {
            draw_chart(df, listr = input$regSelection, input$dose, input$newDailyVac, nor = input$normData)
        }
    })
    
 
    
}

