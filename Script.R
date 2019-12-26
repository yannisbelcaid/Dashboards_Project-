
## app.R ##
library(shiny)
library(shinydashboard)
library(plotly)
library(dplyr)
library(sqldf)
library(RCurl)
library(leaflet)
packageVersion('plotly')


x <- getURL("https://raw.githubusercontent.com/yannisbelcaid/Projet_Shiny_Dashboard/master/Data/full_trains.csv")
data_full_trains <- read.csv(text = x)
y <- getURL("https://raw.githubusercontent.com/yannisbelcaid/Projet_Shiny_Dashboard/master/Data/airports.csv")
data_map <- read.csv(text = y)
z <- getURL("https://raw.githubusercontent.com/yannisbelcaid/Projet_Shiny_Dashboard/master/Data/data_flights_aggregated_3.csv")
data_flights_aggregated_3 <- read.csv(text = z) 


ui <- dashboardPage(
  dashboardHeader(title = "Shiny dashboard",
                  dropdownMenu(type = "messages",
                               messageItem(
                                 from = "Dev Team",
                                 message = "Thank you for using our app", 
                                 icon = icon("fas fa-smile")
                               ),
                               messageItem(
                                 from = "Dev Team",
                                 message = "We wish you a merry christmas",
                                 icon = icon("fas fa-gift"),
                                 time = "2019-12-25"
                               )
                               
                  )),
  dashboardSidebar(
    sidebarMenu(
    menuItem("SNCF Dashboard", tabName = "sncf_dashboard", icon = icon("dashboard")),
    menuItem("Flights Dashboard", tabName = "flights_dashboard", icon = icon("dashboard")), 
    menuSubItem("Airport traffic map", tabName = "map", icon = icon("fas fa-plane-departure"))
  )),
  dashboardBody(
    tabItems(
      tabItem(tabName = "sncf_dashboard",
        fluidRow(
          tabsetPanel(
            type = "tabs",
            tabPanel("Value Box ",  
                     sidebarPanel(
                       selectInput("year", "Year:", 
                                   choices=unique(data_full_trains$year)),
                       hr(),
                       helpText("Dataset from SNCF")
                     ),
                     valueBoxOutput("vbox_1"),
                     valueBoxOutput("vbox_2"), 
                     valueBoxOutput("vbox_3"),
                     valueBoxOutput("vbox_4"),
                     valueBoxOutput("vbox_5"),
                     valueBoxOutput("vbox_6"), 
                     valueBoxOutput("vbox_7"),
                     valueBoxOutput("vbox_8"),
                     valueBoxOutput("vbox_9"),
                     valueBoxOutput("vbox_10"),
                     valueBoxOutput("vbox_11"),
                     valueBoxOutput("vbox_12")),
            
            
            tabPanel("Plot",
                     box(plotlyOutput("plot_1")), 
                     box(plotlyOutput("plot_2")), 
                     box(plotlyOutput("plot_3")), 
                     box(plotlyOutput("plot_7"))
                     
                     ),
            tabPanel("How to use the app", 
                     box(p("Shiny dashboard is the easiest app to use, we've tested many designs to build the most ergonomic user interface"), 
                     p("As you can see, there are 3 tabsets per dashboard."), 
                     p("First tabset : you just have to a select a year and all the value boxes update their value in function of the year"), 
                     p("Second tabset : we've preselected several indicators that we've thought that is interesting to focus on "), 
                     p("Third tabset : you are already on it so we think that you know what is about ")
                     )
              
            )
                     
          )
         
         
          
          )
        ),   
        
      tabItem(tabName = "flights_dashboard", 
              fluidRow(
                tabsetPanel(type = "tabs", 
                            tabPanel("Value box", 
                sidebarPanel(
                  selectInput("airlines", "Airline :", 
                              choices=unique(data_flights_aggregated_3$AIRLINE..10)),
                  hr(),
                  helpText("USA data flights dataset")
                ),
                valueBoxOutput("vbox_f_1"),
                valueBoxOutput("vbox_f_2"), 
                valueBoxOutput("vbox_f_3"),
                valueBoxOutput("vbox_f_4"),
                valueBoxOutput("vbox_f_5"),
                valueBoxOutput("vbox_f_6"), 
                valueBoxOutput("vbox_f_7")
            
              ), 
              tabPanel("Plot", 
                       box(plotlyOutput("plot_4")), 
                       box(plotlyOutput("plot_5")), 
                       box(plotlyOutput("plot_6"), width = 10)
                       ),
              
              tabPanel("How to use the app",
                       box(p("Shiny dashboard is the easiest app to use, we've tested many designs to build the most ergonomic user interface"), 
                           p("As you can see, there are 3 tabsets per dashboard."), 
                           p("First tabset : you just have to a select an airline and all the value boxes update their value in function of the airline"), 
                           p("Second tabset : we've preselected several indicators that we've thought that is interesting to focus on "), 
                           p("Third tabset : you are already on it so we think that you know what is about ")
                       )
                       )
              )
              
              )
      
      ),
      tabItem(tabName = "map",
              fluidRow(
                tabsetPanel(type = "tabs", 
                            tabPanel("map", leafletOutput("map")), 
                            tabPanel('How to use the map', 
                                     box (
                                           p("The map is really esay to use : "),
                                           p(" First of all, you have to zoom in order to see more in details the cluster that you want to see"),
                                           p("After zooming you can click on the marker to see the name of the airport"),
                                           p("That kind of map let us see the zones that are less or more cover by the us traffic")
                                          )
                                    )
                

                            )
                      )
              )
    )
  )
)

server <- function(input, output) { 
  
     output$vbox_1 <- renderValueBox({
       query1 <- data_full_trains %>%
         group_by(year) %>%
         summarise(trains_carried = sum(total_num_trips)-sum(num_of_canceled_trains))
       if (input$year == 2015){
         x <- 1
       }
       if (input$year == 2016){
         x <- 2
       }
       if (input$year == 2017){
         x <- 3
       }
       if (input$year == 2018){
         x <- 4
       }
       valueBox(query1[x,"trains_carried"],"Numbers of trains carried out", icon = icon("train"))
      
     })
     output$vbox_2 <- renderValueBox({
       query2 <- sqldf("select year, sum(num_late_at_departure) as late_at_departure from data_full_trains group by year")
       if (input$year == 2015){
         x <- 1
       }
       if (input$year == 2016){
         x <- 2
       }
       if (input$year == 2017){
         x <- 3
       }
       if (input$year == 2018){
         x <- 4
       }
       valueBox(query2[x,"late_at_departure"]," Number of trains late at departure", icon = icon("train"))
       
     })
     
     output$vbox_3 <- renderValueBox({
       query3 <- sqldf("select year, sum(num_arriving_late) as arrived_late from data_full_trains group by year")
       if (input$year == 2015){
         x <- 1
       }
       if (input$year == 2016){
         x <- 2
       }
       if (input$year == 2017){
         x <- 3
       }
       if (input$year == 2018){
         x <- 4
       }
       valueBox(query3[x,"arrived_late"],"Number of trains wchich arrived late", icon = icon("train"))
       
     })
  
     output$vbox_4 <- renderValueBox({
       query4 <- sqldf("select year , round(avg(num_late_at_departure),3)as avg_num_late_at_departure from data_full_trains group by year")
       if (input$year == 2015){
         x <- 1
       }
       if (input$year == 2016){
         x <- 2
       }
       if (input$year == 2017){
         x <- 3
       }
       if (input$year == 2018){
         x <- 4
       }
       valueBox(query4[x,"avg_num_late_at_departure"],"Average number of delayed trains at departure ", icon = icon("train"))
       
     })
     
     output$vbox_5 <- renderValueBox({
       query5 <- sqldf("select year , round(avg(num_arriving_late),3)as avg_num_arriving_late from data_full_trains group by year")
       if (input$year == 2015){
         x <- 1
       }
       if (input$year == 2016){
         x <- 2
       }
       if (input$year == 2017){
         x <- 3
       }
       if (input$year == 2018){
         x <- 4
       }
       valueBox(query5[x,"avg_num_arriving_late"],"Average number of delayed trains at arrival ", icon = icon("train"))
       
     })
     
     output$vbox_6 <- renderValueBox({
       query6 <- sqldf("select year , round(avg(avg_delay_all_departing),3)as avg_delay_all_departing from data_full_trains group by year")
       if (input$year == 2015){
         x <- 1
       }
       if (input$year == 2016){
         x <- 2
       }
       if (input$year == 2017){
         x <- 3
       }
       if (input$year == 2018){
         x <- 4
       }
       valueBox(query6[x,"avg_delay_all_departing"],"average departure delay time of all trains  (min) ", icon = icon("train"))
       
     })
     
     output$vbox_7 <- renderValueBox({
       query7 <- sqldf("select year , round(avg(avg_delay_all_arriving),3) as avg_delay_all_arriving from data_full_trains group by year")
       if (input$year == 2015){
         x <- 1
       }
       if (input$year == 2016){
         x <- 2
       }
       if (input$year == 2017){
         x <- 3
       }
       if (input$year == 2018){
         x <- 4
       }
       valueBox(query7[x,"avg_delay_all_arriving"],"average arrival delay time of all trains  (min) ", icon = icon("train"))
       
     })
     
     output$vbox_8 <- renderValueBox({
       query8 <- sqldf("select year , round(avg(avg_delay_late_at_departure),3) as avg_delay_late_at_departure from data_full_trains group by year")
       if (input$year == 2015){
         x <- 1
       }
       if (input$year == 2016){
         x <- 2
       }
       if (input$year == 2017){
         x <- 3
       }
       if (input$year == 2018){
         x <- 4
       }
       valueBox(query8[x,"avg_delay_late_at_departure"],"average departure delay time of delayed trains  (min) ", icon = icon("train"))
       
     })
     
     output$vbox_9 <- renderValueBox({
       query9 <- sqldf("select year , round(avg(avg_delay_late_on_arrival),3) as avg_delay_late_on_arrival from data_full_trains group by year")
       if (input$year == 2015){
         x <- 1
       }
       if (input$year == 2016){
         x <- 2
       }
       if (input$year == 2017){
         x <- 3
       }
       if (input$year == 2018){
         x <- 4
       }
       valueBox(query9[x,"avg_delay_late_on_arrival"],"average arrival delay time of delayed trains  (min) ", icon = icon("train"))
       
     })
     
     output$vbox_10 <- renderValueBox({
       query10 <- sqldf("select year , sum(num_of_canceled_trains) as num_of_canceled_trains from data_full_trains group by year")
       if (input$year == 2015){
         x <- 1
       }
       if (input$year == 2016){
         x <- 2
       }
       if (input$year == 2017){
         x <- 3
       }
       if (input$year == 2018){
         x <- 4
       }
       valueBox(query10[x,"num_of_canceled_trains"],"Number of canceled trains", icon = icon("train"))
       
     })
     
     output$vbox_11 <- renderValueBox({
       query11 <- sqldf("select year , (sum(num_of_canceled_trains)*100/sum(total_num_trips)) as perc_of_canceled_trains from data_full_trains group by year")
       if (input$year == 2015){
         x <- 1
       }
       if (input$year == 2016){
         x <- 2
       }
       if (input$year == 2017){
         x <- 3
       }
       if (input$year == 2018){
         x <- 4
       }
       valueBox(query11[x,"perc_of_canceled_trains"],"Percentage of canceled trains (%) ", icon = icon("train"))
       
     })
     
     output$vbox_f_1 <- renderValueBox({
       
       if (input$airlines == "American Airlines Inc."){y <- 1}
       if (input$airlines == "Alaska Airlines Inc."){y <- 2}
       if (input$airlines == "JetBlue Airways"){y <- 3}
       if (input$airlines == "Delta Air Lines Inc."){y <- 4}
       if (input$airlines == "Atlantic Southeast Airlines"){y <- 5}
       if (input$airlines == "Frontier Airlines Inc."){y <- 6}
       if (input$airlines == "Hawaiian Airlines Inc."){y <- 7}
       if (input$airlines == "American Eagle Airlines Inc."){y <- 8}
       if (input$airlines == "Spirit Air Lines"){y <- 9}
       if (input$airlines == "Skywest Airlines Inc."){y <- 10}
       if (input$airlines == "United Air Lines Inc."){y <- 11}
       if (input$airlines == "US Airways Inc."){y <- 12}
       if (input$airlines == "Virgin America"){y <- 13}
       if (input$airlines == "Southwest Airlines Co."){y <- 14}
       
       valueBox(data_flights_aggregated_3[y, "num_flights"], " Number of flights", icon= icon("fas fa-plane-departure"))
       
     })
     
     output$vbox_f_2 <- renderValueBox({
       
       if (input$airlines == "American Airlines Inc."){y <- 1}
       if (input$airlines == "Alaska Airlines Inc."){y <- 2}
       if (input$airlines == "JetBlue Airways"){y <- 3}
       if (input$airlines == "Delta Air Lines Inc."){y <- 4}
       if (input$airlines == "Atlantic Southeast Airlines"){y <- 5}
       if (input$airlines == "Frontier Airlines Inc."){y <- 6}
       if (input$airlines == "Hawaiian Airlines Inc."){y <- 7}
       if (input$airlines == "American Eagle Airlines Inc."){y <- 8}
       if (input$airlines == "Spirit Air Lines"){y <- 9}
       if (input$airlines == "Skywest Airlines Inc."){y <- 10}
       if (input$airlines == "United Air Lines Inc."){y <- 11}
       if (input$airlines == "US Airways Inc."){y <- 12}
       if (input$airlines == "Virgin America"){y <- 13}
       if (input$airlines == "Southwest Airlines Co."){y <- 14}
       
       valueBox(data_flights_aggregated_3[y, "num_delayed_flights"], " Number of delayed flights", icon= icon("fas fa-plane-departure"))
       
     })
     
     
     output$vbox_f_3 <- renderValueBox({
       
       if (input$airlines == "American Airlines Inc."){y <- 1}
       if (input$airlines == "Alaska Airlines Inc."){y <- 2}
       if (input$airlines == "JetBlue Airways"){y <- 3}
       if (input$airlines == "Delta Air Lines Inc."){y <- 4}
       if (input$airlines == "Atlantic Southeast Airlines"){y <- 5}
       if (input$airlines == "Frontier Airlines Inc."){y <- 6}
       if (input$airlines == "Hawaiian Airlines Inc."){y <- 7}
       if (input$airlines == "American Eagle Airlines Inc."){y <- 8}
       if (input$airlines == "Spirit Air Lines"){y <- 9}
       if (input$airlines == "Skywest Airlines Inc."){y <- 10}
       if (input$airlines == "United Air Lines Inc."){y <- 11}
       if (input$airlines == "US Airways Inc."){y <- 12}
       if (input$airlines == "Virgin America"){y <- 13}
       if (input$airlines == "Southwest Airlines Co."){y <- 14}
       
       valueBox(data_flights_aggregated_3[y, "avg_flights_duration"], " Average flight duration (min)", icon= icon("fas fa-plane-departure"))
       
     })
     
     output$vbox_f_4 <- renderValueBox({
       
       if (input$airlines == "American Airlines Inc."){y <- 1}
       if (input$airlines == "Alaska Airlines Inc."){y <- 2}
       if (input$airlines == "JetBlue Airways"){y <- 3}
       if (input$airlines == "Delta Air Lines Inc."){y <- 4}
       if (input$airlines == "Atlantic Southeast Airlines"){y <- 5}
       if (input$airlines == "Frontier Airlines Inc."){y <- 6}
       if (input$airlines == "Hawaiian Airlines Inc."){y <- 7}
       if (input$airlines == "American Eagle Airlines Inc."){y <- 8}
       if (input$airlines == "Spirit Air Lines"){y <- 9}
       if (input$airlines == "Skywest Airlines Inc."){y <- 10}
       if (input$airlines == "United Air Lines Inc."){y <- 11}
       if (input$airlines == "US Airways Inc."){y <- 12}
       if (input$airlines == "Virgin America"){y <- 13}
       if (input$airlines == "Southwest Airlines Co."){y <- 14}
       
       valueBox(data_flights_aggregated_3[y, "avg_flights_distance"], " Average flight distance (miles) ", icon= icon("fas fa-plane-departure"))
       
     })
     
     output$vbox_f_5 <- renderValueBox({
       
       if (input$airlines == "American Airlines Inc."){y <- 1}
       if (input$airlines == "Alaska Airlines Inc."){y <- 2}
       if (input$airlines == "JetBlue Airways"){y <- 3}
       if (input$airlines == "Delta Air Lines Inc."){y <- 4}
       if (input$airlines == "Atlantic Southeast Airlines"){y <- 5}
       if (input$airlines == "Frontier Airlines Inc."){y <- 6}
       if (input$airlines == "Hawaiian Airlines Inc."){y <- 7}
       if (input$airlines == "American Eagle Airlines Inc."){y <- 8}
       if (input$airlines == "Spirit Air Lines"){y <- 9}
       if (input$airlines == "Skywest Airlines Inc."){y <- 10}
       if (input$airlines == "United Air Lines Inc."){y <- 11}
       if (input$airlines == "US Airways Inc."){y <- 12}
       if (input$airlines == "Virgin America"){y <- 13}
       if (input$airlines == "Southwest Airlines Co."){y <- 14}
       
       valueBox(data_flights_aggregated_3[y, "distance_covered_all"], "Distance covered by all airline flights (miles)", icon= icon("fas fa-plane-departure"))
       
     })
     
     output$vbox_f_6 <- renderValueBox({
       
       if (input$airlines == "American Airlines Inc."){y <- 1}
       if (input$airlines == "Alaska Airlines Inc."){y <- 2}
       if (input$airlines == "JetBlue Airways"){y <- 3}
       if (input$airlines == "Delta Air Lines Inc."){y <- 4}
       if (input$airlines == "Atlantic Southeast Airlines"){y <- 5}
       if (input$airlines == "Frontier Airlines Inc."){y <- 6}
       if (input$airlines == "Hawaiian Airlines Inc."){y <- 7}
       if (input$airlines == "American Eagle Airlines Inc."){y <- 8}
       if (input$airlines == "Spirit Air Lines"){y <- 9}
       if (input$airlines == "Skywest Airlines Inc."){y <- 10}
       if (input$airlines == "United Air Lines Inc."){y <- 11}
       if (input$airlines == "US Airways Inc."){y <- 12}
       if (input$airlines == "Virgin America"){y <- 13}
       if (input$airlines == "Southwest Airlines Co."){y <- 14}
       
       valueBox(data_flights_aggregated_3[y, "avg_departure_delay"], "Average departure delay (min)", icon= icon("fas fa-plane-departure"))
       
     })
     
     output$vbox_f_7 <- renderValueBox({
       
       if (input$airlines == "American Airlines Inc."){y <- 1}
       if (input$airlines == "Alaska Airlines Inc."){y <- 2}
       if (input$airlines == "JetBlue Airways"){y <- 3}
       if (input$airlines == "Delta Air Lines Inc."){y <- 4}
       if (input$airlines == "Atlantic Southeast Airlines"){y <- 5}
       if (input$airlines == "Frontier Airlines Inc."){y <- 6}
       if (input$airlines == "Hawaiian Airlines Inc."){y <- 7}
       if (input$airlines == "American Eagle Airlines Inc."){y <- 8}
       if (input$airlines == "Spirit Air Lines"){y <- 9}
       if (input$airlines == "Skywest Airlines Inc."){y <- 10}
       if (input$airlines == "United Air Lines Inc."){y <- 11}
       if (input$airlines == "US Airways Inc."){y <- 12}
       if (input$airlines == "Virgin America"){y <- 13}
       if (input$airlines == "Southwest Airlines Co."){y <- 14}
       
       valueBox(data_flights_aggregated_3[y, "avg_arrival_delay"], "Average arrival delay (min)", icon= icon("fas fa-plane-departure"))
       
     })
     
     
     
     output$map <- renderLeaflet({
       
       m <- leaflet(data_map) %>% 
              addTiles() %>%
                  addMarkers(lng = ~LONGITUDE, lat = ~LATITUDE, # weight = 1,
                             popup = ~paste(AIRPORT), 
                             clusterOptions = markerClusterOptions()
                             # radius = ~sqrt(Population) * 50, popup = ~paste(Ville, ":", Population),
                             # color = "#a500a5", fillOpacity = 0.5
                  )
       m
       
     })
     
     output$plot_1 <- renderPlotly({
       
       
       query_plot_1 <- data_full_trains %>%
         group_by(year) %>%
         summarise(trains_carried = sum(total_num_trips)-sum(num_of_canceled_trains))
       
       p <- plot_ly(query_plot_1, x = ~year, y = ~trains_carried, type = 'bar', name = 'late at departure')
         
       p

     })
     
     output$plot_2 <- renderPlotly({
       
       query2 <- sqldf("select year, sum(num_late_at_departure) as late_at_departure from data_full_trains group by year")
       query3 <- sqldf("select year, sum(num_arriving_late) as arrived_late from data_full_trains group by year")
       query2_3 <- sqldf("select query2.year, late_at_departure, arrived_late from query2 inner join query3 on query2.year = query3.year")
       
       p <- plot_ly(query2_3, x = ~year, y = ~late_at_departure, type = 'bar', name = 'late at departure') %>%
         add_trace(y = ~arrived_late, name = 'late at arrival') %>%
         layout(yaxis = list(title = 'number of trains '), barmode = 'group')
       
       p
       
     })
     
     output$plot_3 <- renderPlotly({
       
       query8 <- sqldf("select year , round(avg(avg_delay_late_at_departure),3) as avg_delay_late_at_departure from data_full_trains group by year")
       query9 <- sqldf("select year , round(avg(avg_delay_late_on_arrival),3) as avg_delay_late_on_arrival from data_full_trains group by year")
       query8_9 <- sqldf("select query8.year, avg_delay_late_at_departure, avg_delay_late_on_arrival from query8 inner join query9 on query8.year = query9.year ")
       
       p <- plot_ly(query8_9, x = ~year, y = ~avg_delay_late_at_departure, type = 'bar', name = 'average departure delay') %>%
         add_trace(y = ~avg_delay_late_on_arrival, name = 'average arrival delay') %>%
         layout(yaxis = list(title = ' average delay (min)'), barmode = 'group')
       
       p
       
     })
     
     output$plot_4 <- renderPlotly({
       
       
       p <- plot_ly(data_flights_aggregated_3, x = ~AIRLINE..10, y = ~avg_departure_delay, type = 'bar', name = 'average departure delay') %>%
         add_trace(y = ~avg_arrival_delay, name = 'average arrival delay') %>%
         layout(yaxis = list(title = ' average delay (min)'), barmode = 'group')
       
       p
       
     })
     
     output$plot_5 <- renderPlotly({
       
       
       p <- plot_ly(data_flights_aggregated_3, x = ~AIRLINE..10, y = ~num_flights, type = 'bar', name = 'number of flights')
       
       p
       
     })
     
     output$plot_6 <- renderPlotly({
       
       
       p <- plot_ly(data_flights_aggregated_3, labels = ~AIRLINE..10, values = ~avg_flights_distance, type = 'pie') %>%
         layout(title = 'Distance covered by all airline flights',
                xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
       
       p
       
     })
     
     output$plot_7 <- renderPlotly({
       
       query10 <- sqldf("select year , sum(num_of_canceled_trains) as num_of_canceled_trains from data_full_trains group by year")
       
       p <- plot_ly(query10, labels = ~year, values = ~num_of_canceled_trains, type = 'pie') %>%
         layout(title = 'Number of canceled trains per year',
                xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
       
       p
       
     })
     
     
  }

shinyApp(ui, server)