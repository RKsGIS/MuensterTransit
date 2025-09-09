## -----------------------------------------------------------------------------
library(MuensterTransit)

# Fetch data from API
fetch_api_data()

# Read GTFS data from the package's inst/extdata folder
gtfs_data <- read_gtfs_files(system.file("extdata", "stadtwerke_feed.zip", package = "MuensterTransit"))

# Access GTFS data from the package
stops <- gtfs_data$stops
routes <- gtfs_data$routes
shapes <- gtfs_data$shapes
trips <- gtfs_data$trips


## -----------------------------------------------------------------------------
# Create a map showing stop locations from GTFS data
plot_stops(stops)


## -----------------------------------------------------------------------------
# Create a map showing flat stop locations from API data
plot_stops_api()


## -----------------------------------------------------------------------------
# Create a map showing vehicle locations from API data
plot_bus_locations_api()


## -----------------------------------------------------------------------------
# Create a map displaying a specific routes
route_id <- 5
plot_specific_route(route_id)


## -----------------------------------------------------------------------------
# Find the nearest bus stop to a given point
lat <- 51.972733
lon <- 7.606783
find_nearest_stop(lat, lon)


## -----------------------------------------------------------------------------
head(find_busiest_stops(stops))


## -----------------------------------------------------------------------------
head(find_busiest_stops_api(stops_data_flat))

## -----------------------------------------------------------------------------
# Find available bus lines for a given bus stop
get_available_buses("Hansaring A")


