
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(raster)
library(rworldmap)
library(rgdal)
library(dplyr)
data("countriesCoarse")
uno <- readRDS("uno.rds")
World <- getData('worldclim', var='bio', res=10)
cities <- readRDS("cities.rds")
shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
    uno[World[[10]] > ifelse(input$degrees == "Celcius", (input$MaxTempC*10), (((input$MaxTempF-32)*5/9)*10))] <- NA
    uno[World[[11]] < ifelse(input$degrees == "Celcius", (input$MinTempC*10), (((input$MinTempF-32)*5/9)*10))] <- NA
    uno[World[[1]] < ifelse(input$degrees == "Celcius", min(input$RangeTempC*10), min(((input$RangeTempF-32)*5/9)*10))] <- NA
    uno[World[[1]] > ifelse(input$degrees == "Celcius", max(input$RangeTempC*10), max(((input$RangeTempF-32)*5/9)*10))] <- NA
    uno[World[[12]] < ifelse(input$degrees == "Celcius", min(input$RangePPC), min(input$RangePPF*25.4))] <- NA
    uno[World[[12]] > ifelse(input$degrees == "Celcius", max(input$RangePPC), max(input$RangePPF*25.4))] <- NA
    plot(uno, col ="red", legend = FALSE)
    plot(countriesCoarse, add = TRUE)
  })
  output$downloadPlot <- downloadHandler(
    filename = function() { paste("WhereToLive", '.png', sep='') },
    content = function(file) {
      png(file)
      uno[World[[10]] > ifelse(input$degrees == "Celcius", (input$MaxTempC*10), (((input$MaxTempF-32)*5/9)*10))] <- NA
      uno[World[[11]] < ifelse(input$degrees == "Celcius", (input$MinTempC*10), (((input$MinTempF-32)*5/9)*10))] <- NA
      uno[World[[1]] < ifelse(input$degrees == "Celcius", min(input$RangeTempC*10), min(((input$RangeTempF-32)*5/9)*10))] <- NA
      uno[World[[1]] > ifelse(input$degrees == "Celcius", max(input$RangeTempC*10), max(((input$RangeTempF-32)*5/9)*10))] <- NA
      uno[World[[12]] < ifelse(input$degrees == "Celcius", min(input$RangePPC), min(input$RangePPF*25.4))] <- NA
      uno[World[[12]] > ifelse(input$degrees == "Celcius", max(input$RangePPC), max(input$RangePPF*25.4))] <- NA
      plot(uno, col ="red", legend = FALSE)
      plot(countriesCoarse, add = TRUE)
      dev.off()
    })
  output$visFun <- renderDataTable({
    uno[World[[10]] > ifelse(input$degrees == "Celcius", (input$MaxTempC*10), (((input$MaxTempF-32)*5/9)*10))] <- NA
    uno[World[[11]] < ifelse(input$degrees == "Celcius", (input$MinTempC*10), (((input$MinTempF-32)*5/9)*10))] <- NA
    uno[World[[1]] < ifelse(input$degrees == "Celcius", min(input$RangeTempC*10), min(((input$RangeTempF-32)*5/9)*10))] <- NA
    uno[World[[1]] > ifelse(input$degrees == "Celcius", max(input$RangeTempC*10), max(((input$RangeTempF-32)*5/9)*10))] <- NA
    uno[World[[12]] < ifelse(input$degrees == "Celcius", min(input$RangePPC), min(input$RangePPF*25.4))] <- NA
    uno[World[[12]] > ifelse(input$degrees == "Celcius", max(input$RangePPC), max(input$RangePPF*25.4))] <- NA
    cities$exists <- extract(uno, cities[,2:3])
    cities <- filter(cities, exists == 1)
    cities <- cities[,c(1,4,5,6)]
    cities
  })
})