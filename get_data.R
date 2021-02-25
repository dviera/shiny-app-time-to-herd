library(tidyverse)
library(lubridate)

get_data <- function(){
  
  pob <- read.csv("poblacion.csv")
  ohipop <- pob[pob$Region == "O'Higgins", "Poblacion"]
  pob$Region[pob$Region == "O'Higgins"] <- "O'Higgins"
  total_pob <- sum(pob$Poblacion)
  url <- "https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto76/vacunacion_std.csv"
  data <- read.csv(url, header = TRUE, encoding = "UTF-8")
  data <- left_join(data, pob, by = "Region")
  data$Fecha <- lubridate::as_date(data$Fecha)
  data$Region[data$Region == "Total"] <- "Chile"
  data[data$Region == "Chile", ]$Poblacion <- total_pob
  data$Poblacion[is.na(data$Poblacion)] <- ohipop
  data$Codigo_Region <- NULL
  data <- data %>% mutate(Perc_Vacunado = round(Cantidad / Poblacion * 100, 2))
  data <- data %>% group_by(Region, Dosis) %>% 
    arrange(Fecha) %>% 
    mutate(daily = c(Cantidad[1], diff(Cantidad)))
  
  return(data)
}


