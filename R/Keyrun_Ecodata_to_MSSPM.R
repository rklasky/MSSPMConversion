#
# Keyrun_Ecodata_to_MSSPM ######################################################
#
#
## Brief Description ###########################################################
# Script to convert Keyrun ecodata to MSSPM environmental covariate data
#
#
## Detailed Description ########################################################
#
# This function takes a list of ecodata tables and converts them into an MSSPM
# covariate csv file.
#
#
## Example Usage ###############################################################
# remotes::install_github("NOAA-EDAB/ecodata")
#
# colNames <- list("chloro_a","bottom_temp","sea_surface_temp")
# inputDataFrames <- list(ecodata::chl_pp,ecodata::bottom_temp,ecodata::seasonal_oisst_anom))
# region <- "GB"
# vars <- list("ANNUAL_PPD_MEDIAN","bottom temp anomaly in situ","Spring OISST anomaly")
# outputFile <- '/home/rklasky/test/Covariate_Keyrun.csv'
#
# convertEcodataToMSSPM(colNames,inputDataFrames,region,vars,outputFile)

## roxygen help ################################################################
#' Keyrun Ecodata to MSSPM Environmental Covariate Conversion
#'
#' Conversion of Keyrun (i.e., Ecodata) Environmental Covariate data to an MSSPM Covariate csv file
#' @param colNames The names of the covariate parameters that are used in MSSPM
#' @param inputDataFrame The input Ecodata data frames
#' @param region The geographical region of interest (i.e., "GB","GOM","MAB")
#' @param vars The description used in the data frame to specify the desired years' data
#' @param outputfile The output csv data file containing the MSSPM Covariate
#' formatted data. N.B. The csv file must begin with "Covariate_".
#' @return n/a
#' @examples
#' remotes::install_github("NOAA-EDAB/ecodata")
#'
#' colNames <- list("chloro_a","bottom_temp","sea_surface_temp")
#' inputDataFrames <- list(ecodata::chl_pp,ecodata::bottom_temp,ecodata::seasonal_oisst_anom)
#' region <- "GB" # GB, GOM, or MAB (i.e., George's Bank, Gulf of Maine, Mid-Atlantic Bight)
#' vars <- list("ANNUAL_PPD_MEDIAN","bottom temp anomaly in situ","Spring OISST anomaly")
#' outputFile <- '/home/rklasky/test/Covariate_Keyrun.csv'
#'
#' convertEcodataToMSSPM(colNames,inputDataFrames,region,vars,outputFile)
#'

#' @export
#'
convertEcodataToMSSPM <- function(colNames,inputDataFrames,region,vars,outputFile) {
  NO_DATA   <- -99999 # used when data are missing
  minYear   <-   9999 # used to find the minimum year of all of the ecodata data frames listed
  maxYear   <-      0 # used to find the maximum year of all of the ecodata data frames listed
  startYear <-   1500 # used to set the start year for the final data frame (extraneous rows will be deleted)
  endYear   <-   2500 # used to set the end year for the final data frame (extraneous rows will be deleted)

  # Set up the final merged data frame with just a single "year" column and populate it
  mergedCovariateDataFrame <- as.data.frame(matrix(nrow=(endYear-startYear+1),ncol=1))
  base::colnames(mergedCovariateDataFrame) <- c("year")
  mergedCovariateDataFrame$year <- base::seq(startYear,endYear,by=1)

  # For each ecodata data frame specified, find the max/min years and then copy the relevant
  # data from the ecodata data frame to the final merged data frame
  for (i in base::seq_along(inputDataFrames)) {
    name <- colNames[[i+1]] # the name of the environmental covariate (skip "year")
    inputDataFrame <- inputDataFrames[[i]] # the data frame containing the covariate data
    desc <- vars[[i]] # a descriptive field in each of the covariate data frames

    # Extract the relevant data from the data frame
    timeValueDataFrame <- extractTimeValueData(inputDataFrame,region,desc)

    # Find the minimum and maximum of all years of all data frames
    dfMinYear <- base::min(timeValueDataFrame$year)
    dfMaxYear <- base::max(timeValueDataFrame$year)
    minYear   <- as.integer(ifelse((dfMinYear < minYear),dfMinYear,minYear))
    maxYear   <- as.integer(ifelse((dfMaxYear > maxYear),dfMaxYear,maxYear))

    # Merge the recently extracted data frame into the merged data frame
    mergedCovariateDataFrame <- dplyr::left_join(mergedCovariateDataFrame,timeValueDataFrame,by="year")

    print(base::paste0("Processing covariate: ",name," (",dfMinYear," to ",dfMaxYear,", ",dfMaxYear-dfMinYear+1," year(s))"))
  }

  # Replace all NA values with NO_DATA values and set the column names
  mergedCovariateDataFrame[is.na(mergedCovariateDataFrame)] <- "" #NO_DATA
  base::colnames(mergedCovariateDataFrame) <- colNames

  # Remove any superfluous rows before the first row with data or after the last row with data
  mergedCovariateDataFrame <- base::subset(mergedCovariateDataFrame,
        mergedCovariateDataFrame$year >= minYear & mergedCovariateDataFrame$year <= maxYear)

  # Sort columns by name
  mergedCovariateDataFrame <- mergedCovariateDataFrame[,base::order(base::colnames(mergedCovariateDataFrame))]

  # Move the "year" column to the 1st position
  mergedCovariateDataFrame <- dplyr::select(mergedCovariateDataFrame,"year",everything())

  # Write out the data frame as a csv file
  readr::write_csv(mergedCovariateDataFrame,outputFile)

  return(mergedCovariateDataFrame)
  #View(mergedCovariateDataFrame)
}

extractTimeValueData <- function(inputDataFrame,region,desc) {

  # Subset the table with the required region and description values
  ecoData <- base::subset(inputDataFrame, EPU==region & Var==desc)

  # Remove any non-numeric characters from the Time column (some data frames have a non-numeric prefix)
  ecoData$Time <- base::gsub("[^0-9.-]","",ecoData$Time)

  # Keep only the columns MSSPM will need
  timeValueDataFrame <- dplyr::select(ecoData, Time, Value)

  # Rename "Time" column name to be "year"
  base::colnames(timeValueDataFrame)[base::colnames(timeValueDataFrame) == "Time"] <- "year"

  # Cast fields as needed
  timeValueDataFrame$year  <- as.integer(timeValueDataFrame$year)
  timeValueDataFrame$Value <- as.character(timeValueDataFrame$Value)

  # Return the data frame with the desired columns
  return(timeValueDataFrame)
}
