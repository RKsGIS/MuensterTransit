#' Finds the nearest bus stop to a given point in GTFS data.
#'
#' @param lat Latitude of the point.
#' @param lon Longitude of the point.
#' @return Data for the nearest bus stop.
#'
#' @details
#' Finds the nearest bus stop to a given point from GTFS data.
#' Given a Latitude and longitude, returns the information about the nearest bus stop.
#'
#' @usage
#' find_nearest_stop(lat, lon)
#'
#' @seealso
#' \code{\link{plot_stops_api}}
#' \code{\link{plot_stops}}
find_nearest_stop <- function(lat, lon) {
  # Calculate distances between the given point and all bus stops
  distances <- geosphere::distGeo(stops[, c("stop_lon", "stop_lat")], c(lon, lat))

  # Find the index of the bus stop with the shortest distance
  nearest_stop_index <- which.min(distances)

  # Return the data for the nearest bus stop
  return(stops$stop_name[nearest_stop_index])
}

#' Find available bus lines for a given bus stop from API data.
#'
#' @param stop_name The name of the bus stop
#' @param stops_data_flat A data frame containing flat stop location information
#' @return Data for the available bus lines from the bus stop.
#'
#' @details
#' Find available bus lines for a given bus stop from API
#' and returns the information about the buses at that stop and time.
#'
#' @usage
#' get_available_buses("stop_name")
#'
#' @seealso
#' \code{\link{plot_stops_api}}
#' \code{\link{plot_bus_locations_api}}
get_available_buses <- function(stop_name) {
  stop_filtered <- stops_data_flat$properties %>%
    dplyr::filter(lbez == stop_name)

  if (nrow(stop_filtered) == 0) {
    cat("Bus stop not found.\n")
    return(NULL)
  }

  linienfilter <- stop_filtered$linienfilter

  if (all(is.na(linienfilter))) {
    cat("No available bus lines for this stop.\n")
  } else {
    cat("Available bus lines for", stop_name, ":")
    cat(ifelse(all(is.na(linienfilter)), " None", paste(linienfilter, collapse = ", ")))
    cat("\n")
  }
}

#' Finds most common stops based on GTFS data
#'
#' @param stop_data A data frame with stop information
#' @return A data frame with the most common stops
#'
#' @details
#' Finds the most common and busiest stops based on GTFS data.
#'
#' @usage
#' find_busiest_stops(stop_data)
#'
#' @seealso
#' \code{\link{plot_stops_api}}
#' \code{\link{plot_stops}}
find_busiest_stops <- function(stop_data) {
  most_common_stops <- table(stop_data$stop_name)
  most_common_stops <- most_common_stops[order(most_common_stops, decreasing = TRUE)]
  return(most_common_stops)
}

#' Finds most common stops based on API data
#'
#' @param stop_data A data frame with stop information
#' @return A data frame with the most common stops
#'
#' @details
#' Finds the most common and busiest stops based on API data.
#'
#' @usage
#' find_busiest_stops_api(stop_data)
#'
#' @seealso
#' \code{\link{plot_stops_api}}
#' \code{\link{plot_stops}}
find_busiest_stops_api <- function(stop_data) {
  most_common_stops <- table(stop_data$properties$lbez)
  most_common_stops <- most_common_stops[order(most_common_stops, decreasing = TRUE)]
  return(most_common_stops)
}
