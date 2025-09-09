#' Fetch Data from Remote API
#'
#' Fetches vehicle and stops data from a remote API and stores it in the global environment.
#'
#' @return None
#'
#' @details
#' This function fetches real-time vehicle data and stops data from a remote API and stores them in the global environment. It uses the 'httr' and 'jsonlite' packages to make HTTP requests and parse JSON responses.
#'
#' The fetched vehicle data includes information such as line ID, line text, departure information, and geographical coordinates. The fetched stops data includes properties and coordinates of stops.
#'
#' The fetched data is stored in the global environment with variable names 'vehicle_data' and 'stops_data_flat'.
#'
#'
#' @seealso
#' \code{\link{plot_stops_api}}
#' \code{\link{plot_bus_locations_api}}
#' \code{\link{find_busiest_stops_api}}
#' \code{\link{get_available_buses}}
#' @export
fetch_api_data <- function() {
  # Fetch vehicle data
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

  # Store in environment
  assign("vehicle_data", vehicle_data, envir = .GlobalEnv)

  # Fetch stops data
  response_stops <- httr::GET("https://rest.busradar.conterra.de/prod/haltestellen/")
  data_stops <- httr::content(response_stops, "text")
  parsed_data_stops <- jsonlite::fromJSON(data_stops)
  coordinates <- parsed_data_stops$features$geometry$coordinates
  stops_data_flat <- parsed_data_stops$features %>%
    dplyr::select(properties, geometry) %>%
    tidyr::unnest(geometry)

  # Store in environment
  assign("stops_data_flat", stops_data_flat, envir = .GlobalEnv)
}



#' Reads GTFS text files and prepares data for analysis.
#'
#' @param gtfs_path Path to the directory containing GTFS text files
#'
#' @return A list of data tables containing GTFS data and
#'
#' @import data.table
#'
#'#' @seealso
#' \code{\link{plot_stops}}
#' \code{\link{plot_specific_route}}
#' \code{\link{find_nearest_stop}}
#' \code{\link{find_busiest_stops}}
read_gtfs_files <- function(gtfs_path) {
  temp_dir <- tempdir()
  unzip_dir <- file.path(temp_dir, "gtfs_extracted")
  unzip(gtfs_path, exdir = unzip_dir)

  extracted_files <- list.files(unzip_dir, full.names = TRUE)

  gtfs_data <- list()
  for (file_path in extracted_files) {
    file_name <- tools::file_path_sans_ext(basename(file_path))
    data <- data.table::fread(file_path, integer64 = "character", showProgress = FALSE)
    gtfs_data[[file_name]] <- data
  }
  # Extract specific data tables for easy access
  assign("calendar_dates", gtfs_data$calendar_dates, envir = globalenv())
  assign("routes", gtfs_data$routes, envir = globalenv())
  assign("shapes", gtfs_data$shapes, envir = globalenv())
  assign("stop_times", gtfs_data$stop_times, envir = globalenv())
  assign("stops", gtfs_data$stops, envir = globalenv())
  assign("trips", gtfs_data$trips, envir = globalenv())

  unlink(unzip_dir, recursive = TRUE)

  return(gtfs_data)
}
