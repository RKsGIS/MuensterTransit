#' Creates a Leaflet map showing stop locations from GTFS data.
#' @param stops_data A data frame containing stop locations
#' @return A Leaflet map object
#' @details
#' Creates a Leaflet map showing bus stop locations from the given GTFS data
#' @usage
#' plot_stops(stops_data)
#' @seealso
#' \code{\link{plot_stops_api}}
#'
plot_stops <- function(stops_data) {
  map <- leaflet() %>%
    addTiles() %>%
    addCircleMarkers(data = stops_data, lng = ~stop_lon, lat = ~stop_lat,
                     stroke = FALSE, fillOpacity = 0.5, radius = 5,
                     color = "blue")
  return(map)
}

#' Creates a Leaflet map showing stop locations from API.
#' @param stops_data_flat A data frame containing flat stop location information
#' @return A Leaflet map object
#' @details
#' Creates a Leaflet map showing bus stop locations from the given API data
#' @usage
#' plot_stops_api()
#' @seealso
#' \code{\link{plot_stops}}
plot_stops_api <- function() {
  # Convert the coordinates list to a data frame
  coordinates_df <- data.frame(
    longitude = sapply(stops_data_flat$coordinates, "[[", 1),
    latitude = sapply(stops_data_flat$coordinates, "[[", 2)
  )

  # Combine the coordinates data with properties
  stops_with_coords <- cbind(stops_data_flat$properties, coordinates_df)

  # Create the Leaflet map
  map <- leaflet() %>%
    addTiles() %>%
    addCircleMarkers(data = stops_with_coords, lng = ~longitude, lat = ~latitude,
                     stroke = FALSE, fillOpacity = 0.5, radius = 5,
                     color = "blue",
                     popup = ~paste("Stop Name:", lbez, "<br>",
                                    "Stop Number:", nr, "<br>",
                                    "Type:", typ))

  return(map)
}

#' Creates a Leaflet map showing vehicle locations from API.
#' @details
#' Creates a Leaflet map showing bus locations from the given API data.
#' display live location of the vehicle
#' @usage
#' plot_bus_locations_api()
#' @seealso
#' \code{\link{get_available_buses}}
#' @return A Leaflet map object
plot_bus_locations_api <- function(...) {
  # Function implementation for fetching vehicle data from API
  vehicle_url <- "https://rest.busradar.conterra.de/prod/fahrzeuge"
  response_vehicle <- httr::GET(vehicle_url)
  data_vehicle <- httr::content(response_vehicle, "text")
  parsed_data_vehicle <- jsonlite::fromJSON(data_vehicle)
  vehicle_data <- data.frame(
    linienid = parsed_data_vehicle$features$properties$linienid,
    linientext = parsed_data_vehicle$features$properties$linientext,
    fahrtbezeichner = parsed_data_vehicle$features$properties$fahrtbezeichner,
    betriebstag = parsed_data_vehicle$features$properties$betriebstag,
    sequenz = parsed_data_vehicle$features$properties$sequenz,
    abfahrtstart = parsed_data_vehicle$features$properties$abfahrtstart,
    ankunftziel = parsed_data_vehicle$features$properties$ankunftziel,
    zielhst = parsed_data_vehicle$features$properties$zielhst,
    longitude = sapply(parsed_data_vehicle$features$geometry$coordinates, "[[", 1),
    latitude = sapply(parsed_data_vehicle$features$geometry$coordinates, "[[", 2)
  )
  map <- leaflet() %>%
    addTiles() %>%
    addCircleMarkers(data = vehicle_data, lng = ~longitude, lat = ~latitude,
                     stroke = FALSE, fillOpacity = 0.5, radius = 5,
                     color = "red",
                     popup = ~paste("LinienID:", linienid, "<br>",
                                    "LinienText:", linientext, "<br>",
                                    "Fahrtbezeichner:", fahrtbezeichner, "<br>",
                                    "Betriebstag:", betriebstag, "<br>",
                                    "Sequenz:", sequenz, "<br>",
                                    "Abfahrt Start:", abfahrtstart, "<br>",
                                    "Ankunft Ziel:", ankunftziel, "<br>",
                                    "Zielhst:", zielhst))
  return(map)
}



#' Creates a Leaflet map displaying a specific route from GTFS data.
#' @details
#' Creates a Leaflet map displaying a specific route when given a bus number(route_id)
#' displays from GTFS data
#' @usage
#' plot_specific_route(route_id)
#' @seealso
#' \code{\link{plot_bus_locations_api}}
#' @param route_id The ID of the route to display
#' @return A Leaflet map object
plot_specific_route <- function(route_id) {
  # Filter shapes data for the specified route_id
  route_shapes <- shapes[shapes$shape_id %in% trips$shape_id[trips$route_id == route_id], ]

  # Filter stops data for the specified route_id
  route_stops <- stops[stops$stop_id %in% stop_times$stop_id[stop_times$trip_id %in% trips$trip_id[trips$route_id == route_id]], ]

  # Extract coordinates for shapes and stops
  route_shapes_coords <- route_shapes[, c("shape_pt_lat", "shape_pt_lon")]
  route_stops_coords <- route_stops[, c("stop_lat", "stop_lon")]

  # Create a Leaflet map
  map <- leaflet() %>%
    addTiles() %>%
    addPolylines(data = route_shapes, color = "blue", weight = 3, lng = ~shape_pt_lon, lat = ~shape_pt_lat) %>%
    addCircleMarkers(data = route_stops, color = "red", radius = 5, lng = ~stop_lon, lat = ~stop_lat)

  return(map)
}
