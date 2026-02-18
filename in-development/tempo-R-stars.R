library(sf)
library(stars)
library(earthdatalogin)
library(dplyr)
library(ggplot2)
library(viridis)
library(units)

# Ensure netrc is set up
edl_netrc()

# Same NetCDF file URL
nc_file <- "https://data.asdc.earthdata.nasa.gov/asdc-prod-protected/TEMPO/TEMPO_NO2_L3_V03/2024.09.01/TEMPO_NO2_L3_V03_20240901T153815Z_S007.nc"

# Read specific variables using stars
# Use /vsicurl/ prefix for authenticated remote access
vsicurl_file <- paste0("/vsicurl/", nc_file)

meta <- gdal_utils("mdiminfo", vsicurl_file) |>
  jsonlite::fromJSON()

meta$attributes
names(meta$groups)
names(meta$groups$product$arrays)
meta$groups$product$arrays$vertical_column_stratosphere

crs <- meta$attributes$geospatial_bounds_crs

no2_trop_stars <- read_mdim(
  vsicurl_file,
  variable = "//product/vertical_column_troposphere",
  proxy = TRUE
) |>
  st_set_crs(crs)

no2_strat_stars <- read_mdim(
  vsicurl_file,
  variable = "//product/vertical_column_stratosphere",
  proxy = TRUE
) |>
  st_set_crs(crs)

no2_data_quality <- read_mdim(
  vsicurl_file,
  variable = "//product/main_data_quality_flag",
  proxy = TRUE
) |>
  st_set_crs(crs)

good_data_mask <- no2_data_quality == 0 &
  no2_trop_stars > 0 &
  no2_strat_stars > 0

no2_trop_stars_good <- no2_trop_stars[good_data_mask]
no2_strat_stars_good <- no2_strat_stars[good_data_mask]

# OR
# no2_trop_stars_good <- filter(no2_trop_stars, good_data_mask)
# no2_strat_stars_good <- filter(no2_strat_stars, good_data_mask)

POI_lat <- 38.0
POI_lon <- -96.0

dlat <- 5
dlon <- 6

bbox <- st_bbox(
  c(
    xmin = POI_lon - dlon,
    ymin = POI_lat - dlat,
    xmax = POI_lon + dlon,
    ymax = POI_lat + dlat
  ),
  crs = crs
)

no2_trop_stars_cropped <- st_crop(no2_trop_stars_good, bbox)
no2_strat_stars_cropped <- st_crop(no2_strat_stars_good, bbox)

all_no2 <- no2_trop_stars_cropped + no2_strat_stars_cropped

plot(all_no2 / 1e16, col = viridisLite::viridis, breaks = "equal")

ggplot() +
  geom_stars(data = st_as_stars(all_no2) |> units::drop_units() / 1e16) +
  # add states boundaries
  annotation_borders(
    "state",
    colour = "lightgrey",
    fill = NA,
  ) +
  coord_equal(
    xlim = as.numeric(bbox)[c(1, 3)],
    ylim = as.numeric(bbox)[c(2, 4)]
  ) +
  theme_void() +
  scale_fill_viridis()

# Read the three main variables
# no2_trop_stars <- read_stars(
#   vsicurl_file,
#   sub = c(
#     "//product/vertical_column_troposphere",
#     "//product/vertical_column_stratosphere",
#     "//product/main_data_quality_flag"
#   ),
#   driver = "HDF5",
#   proxy = TRUE
# )
