Shiny dashboard Project
========================================================
author: BEAZIZ Raphaël, BELCAID Yannis, IEHL Marc-Antoine
date: 26/12/2019
autosize: true


Links
========================================================

You can click on links below to see all the information that you need to evaluate our project. 

-  Github : https://github.com/yannisbelcaid/Dashboards_Project-/tree/master/Data
-  shinyapps.io : https://yannisbelcaid.shinyapps.io/Dashboards_Project-/
-  Rpubs : 


SNCF dashboard
========================================================

We've decided to use the full_trains.csv file to create sncf dashboard.
You can see below the first line of the data set in order to get an idea of the structure of it. 

```
  year month  service departure_station arrival_station journey_time_avg
1 2017     9 National         PARIS EST            METZ         85.13378
  total_num_trips num_of_canceled_trains comment_cancellations
1             299                      0                    NA
  num_late_at_departure avg_delay_late_at_departure avg_delay_all_departing
1                    15                       11.55               0.7520067
  comment_delays_at_departure num_arriving_late avg_delay_late_on_arrival
1                          NA                17                  13.79412
  avg_delay_all_arriving comment_delays_on_arrival delay_cause_external_cause
1              0.4198439                      <NA>                       0.25
  delay_cause_rail_infrastructure delay_cause_traffic_management
1                               0                      0.1666667
  delay_cause_rolling_stock delay_cause_station_management
1                 0.4166667                      0.1666667
  delay_cause_travelers num_greater_15_min_late avg_delay_late_greater_15_min
1                     0                       6                      24.03333
  num_greater_30_min_late num_greater_60_min_late
1                       1                       0
```

SNCF dashboard 
========================================================

In our tabset "Plot", we've selected few indicators that we thought interresting to focus on as the plot below (we were obliged to put links to Rpubs for the plots because it caused many problems in the presentation) : 
-  http://rpubs.com/yannisbelcaid/562620) 


Insights SNCF dashboard
========================================================
We've noticed that there are more and more delay throught the year. The delay are bigger at arrival than at departure. The number of canceled trains increase throught the year too. 


Flights dashboard 
========================================================

In order to realise the flights dashboard, we've done some preprocessing. 
We've created a new csv file that we called "data_flights_aggregated_3".
This file contains per ailine : 
 - Total number of flights 
 - Total number of delayed flights 
 - The average flight duration 
 - The average flight distance 
 - The total distance covered by all airline flights 
 - The average departure delay 
 - The average arrival delay


Flights dashboard 
========================================================
 
In order to get an idea of the strucrure of "data_flights_aggregated_3", let's see the fisrt line of this file :  

```
  X AIRLINE num_flights num_delayed_flights avg_flights_duration
1 1      AA      187472              187472              169.691
  avg_flights_distance distance_covered_all avg_departure_delay
1             1034.759            193988318              42.546
  avg_arrival_delay IATA_CODE            AIRLINE..10
1            41.899        AA American Airlines Inc.
```

Flights dashboard 
========================================================

In our tabset "Plot", we've selected few indicators that we thought interresting to focus on as the plot below : 
- http://rpubs.com/yannisbelcaid/562621




Map  
========================================================

We've created a map in order to have an idea of the airline traffic in the us. 
The map display by cluster, all the airports, you can click on the marker to have the name of the airport. 

- http://rpubs.com/yannisbelcaid/562625 



```
Error in file(con, "rb") : impossible d'ouvrir la connexion
```
