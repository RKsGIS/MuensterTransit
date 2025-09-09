# MuensterTransit

An R package for analyzing and visualizing Münster's public transit system.

## Features

- Fetch and analyze Münster public transit data (GTFS + API)
- Visualize routes, stops, and live buses in R
- Find nearest stops, available lines, and busiest stops

## Usage

```r
library(MuensterTransit)

# Get transit data
data <- get_transit_data()

# Find nearest stops
stops <- find_nearest_stops(lat = 51.9606, lon = 7.6261)

# Visualize routes
plot_routes(data)
```

## Credits

**Author:** RKsGIS  
**License:** MIT
