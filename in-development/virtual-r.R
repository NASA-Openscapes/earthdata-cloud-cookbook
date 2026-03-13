library(terra)
library(stars)
library(earthdatalogin)

# https://gdal.org/en/stable/drivers/raster/zarr.html

# Need to build sf, stars, and terra from source with GDAL >= 3.11 to support
# kerchunk json references

edl_netrc()

unloadGDALdrivers("netCDF")

vz_file <- "https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/virtual_collections/MUR25-JPL-L4-GLOB-v04.2/MUR25-JPL-L4-GLOB-v04.2_virtual_https.json"

local_file <- "MUR25-JPL-L4-GLOB-v04.2_virtual_https.json"

prefix <- "/vsicurl/"
# prefix <- "/vsikerchunk_json_ref/"

## sf/stars

meta <- gdal_utils("mdiminfo", paste0(local_file)) |>
  jsonlite::fromJSON()

stars::read_mdim(
  paste0(prefix, vz_file),
  variable = "analysed_sst",
  # raster = c("/lon", "/lat"),
  proxy = TRUE
)

stars::read_stars(
  paste0(prefix, vz_file),
  sub = "analysed_sst",
  proxy = TRUE,
  along = list(
    time = seq(
      as.POSIXct("1981-01-01 00:00:00", tz = "UCT"),
      length.out = meta$dimensions$size[3],
      by = "1 day"
    )
  )
)

meta <- gdal_utils("mdiminfo", paste0(prefix, vz_file))

## terra

terra::describe(paste0(prefix, vz_file))

terra::ar_info(paste0(prefix, vz_file), what = "describe")
terra::ar_info(paste0(prefix, vz_file), what = "arrays")
terra::ar_info(
  paste0(prefix, vz_file),
  what = "dimensions",
  array = "analysed_sst",
)

ras <- terra::rast(
  vz_file,
  subds = "/analysed_sst",
  vsi = TRUE #,
  # md = TRUE #,
  # names = seq(
  #   as.POSIXct("1981-01-01 00:00:00", tz = "UCT"),
  #   length.out = 8359,
  #   by = "1 day"
  # )
)

names(ras) <- seq(
  as.POSIXct("2002-08-31 00:00:00", tz = "UCT"),
  length.out = 8359,
  by = "1 day"
)

POI_lat <- 38.0
POI_lon <- -96.0

dlat <- 5
dlon <- 6

extent <- terra::ext(
  POI_lon - dlon,
  POI_lon + dlon,
  POI_lat - dlat,
  POI_lat + dlat
)

ras_cropped <- terra::crop(ras, extent)
