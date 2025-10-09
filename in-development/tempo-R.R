library(terra)
library(earthdatalogin)

edl_netrc()

unloadGDALdrivers("netCDF")

nc_file <- "https://data.asdc.earthdata.nasa.gov/asdc-prod-protected/TEMPO/TEMPO_NO2_L3_V03/2024.09.01/TEMPO_NO2_L3_V03_20240901T153815Z_S007.nc"

meta <- terra::ar_info(paste0("/vsicurl/", nc_file))
meta <- terra::describe(paste0("/vsicurl/", nc_file), sds = TRUE)
meta

no2_trop <- terra::rast(
  nc_file,
  subds = "//product/vertical_column_troposphere",
  vsi = TRUE,
  md = TRUE
)
no2_strat <- terra::rast(
  nc_file,
  subds = "//product/vertical_column_stratosphere",
  vsi = TRUE,
  md = TRUE
)

no2_trop
no2_strat

quality_flag <- terra::rast(
  nc_file,
  subds = "//product/main_data_quality_flag",
  vsi = TRUE,
  md = TRUE
)

good_data_mask <- quality_flag == 0 & no2_trop > 0 & no2_strat > 0

good_trop_no2 <- terra::mask(no2_trop, good_data_mask)
good_strat_no2 <- terra::mask(no2_strat, good_data_mask)

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
no2_trop_cropped <- terra::crop(good_trop_no2, extent)
no2_strat_cropped <- terra::crop(good_strat_no2, extent)

plot(no2_trop_cropped, main = "TEMPO Tropospheric NO2 col (molecules/cm²)")
plot(no2_strat_cropped, main = "TEMPO Stratospheric NO2 col (molecules/cm²)")

plot(
  (no2_trop_cropped + no2_strat_cropped) / 1e16,
  main = "TEMPO Total NO2 col (molecules/cm²)"
)
