# Time to Herd & Vaccination Tracker COVID-19 CHILE

Shiny App to track the evolution of the COVID-19 vaccination in Chile and calculate the time to herd immunity.

## Time to Herd
- I used a 70% of the population vaccinated to reach herd immunity.
- 7-day moving average of the daily doses administered was uses as the current rate of vaccination.
- Formula:

    Time to Herd = ( Population * 0.7  - First Dose Administered * 0.5) / (7-day moving average of daily doses administered * 0.5) 

- Access the app here [https://notaico.shinyapps.io/vacapp19/](https://notaico.shinyapps.io/vacapp19/)