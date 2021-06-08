#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


### Creating a OpenStreetMap of Knepp estate

# Call relevant packages (assuming installed)
library(shiny)
library(leaflet)
library(htmltools)
library(shiny)

# Define data frame of site names and coordinates
marker_df <- read.csv(textConnection(
    "Name,Lat,Long
Knepp,50.98341,-0.35485
Wadhurst,51.03579,0.32769
Wintershall,51.16605,-0.55289"))

# Define the UI for the Shiny app
ui <- fluidPage(
    leafletOutput("mymap"),
    p(),
    actionButton("recalc", "New points")
)

# Create map as server
server <- function(input, output, session) {
    
    points <- eventReactive(input$recalc, {
        cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
    }, ignoreNULL = FALSE)
    
    output$mymap <- renderLeaflet({
        leaflet(marker_df) %>% 
            addTiles() %>%
            setView(lng=-0.35485, lat=50.98341, zoom = 9) %>% 
            addMarkers(lng=~Long, lat=~Lat, popup = ~htmltools::htmlEscape(Name)) %>%
            addCircles(lng=-0.35485, lat=50.98341, color = "red", radius = 15000) %>% 
            addCircles(lng=0.32769, lat=51.03579, color = "blue", radius = 15000) %>% 
            addCircles(lng=-0.55289, lat=51.16605, color = "green", radius = 15000) %>% 
            addMeasure() %>%
            addMiniMap()
    })
}

# Run the Shiny app map
shinyApp(ui, server)

