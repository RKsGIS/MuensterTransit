
# MuensterTransit 🚌

`MuensterTransit` is an R package for fetching, analyzing, and visualizing public transportation data for Stadt Münster, Germany.

This package provides reusable functions to work with both real-time API data and static GTFS feeds. It is designed as a practical spatial analysis and transit data toolkit.


---

## Overview

`MuensterTransit` allows users to:

- Fetch real-time bus location data from the Münster Busradar API
- Read and process GTFS (General Transit Feed Specification) data
- Visualize transit data on interactive Leaflet maps
- Perform spatial analysis such as nearest stop detection
- Identify high-frequency or busy transit stops
- Explore routes, stops, and vehicle movement patterns

---

## Installation

You can install the development version directly from GitHub:

```r
# install.packages("devtools")
devtools::install_github("RKsGIS/MuensterTransit")
```

---

## Quick Start

Load the package:

```r
library(MuensterTransit)
```

Fetch live bus data:

```r
fetch_api_data()
```

Plot live bus locations:

```r
plot_bus_locations_api()
```

Read GTFS data:

```r
gtfs_data <- read_gtfs_files("path/to/stadtwerke_feed.zip")
```

Find the nearest stop to a coordinate:

```r
find_nearest_stop(lat = 51.9727, lon = 7.6067)
```

---

## Documentation

A full example analysis and usage guide is available in: 
[full Package Vignette & Examples](https://rksgis.github.io/MuensterTransit/inst/doc/Muenster_PublicTransAnalysis.html)

This vignette demonstrates step-by-step usage of the package functions for real-time and GTFS-based transit analysis.

---

## Project Structure

```
MuensterTransit/
├── R/                # Core functions (API, analysis, visualization)
├── inst/extdata/     # GTFS feed data
├── inst/doc/         # HTML vignette and documentation
├── DESCRIPTION       # Package metadata and dependencies
├── NAMESPACE         # Exported functions
└── README.md
```

---

## Tech Stack

- R (>= 3.5.0)
- leaflet
- sf
- geosphere
- dplyr
- jsonlite
- httr
- data.table

---

## Purpose

This project demonstrates:

- R package development
- REST API integration in R
- GTFS data processing
- Spatial analysis using `sf`
- Interactive mapping with `leaflet`
- Reproducible transit data workflows

---

## Author
 [Ram Kumar Muthusamy](mailto:ramkumar.m@uni-muenster.de)

Developed as part of the Spatio-Temporal Analysis course at the University of Münster.


