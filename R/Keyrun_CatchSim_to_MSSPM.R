#
# Keyrun_CatchSim_to_MSSPM ######################################################
#
#
## Brief Description ###########################################################
# Script to convert Keyrun (i.e., Atlantis) simulated catch index file to MSSPM catch file
#
#
## Detailed Description ########################################################
#
# This function takes the input Keyrun (i.e., Atlantis) data frame, converts it
# to an MSSPM formatted data frame, and writes it out to the passed
# CSV file.
#
#
## Example Usage ###############################################################
#
# inputDataFrame <- mskeyrun::simCatchIndex
# startYear <- 55
# outputFile <- '/home/rklasky/test/HarvestCatch_Keyrun_simulated.csv'
# convertKeyrunCatchSimToMSSPM(inputDataFrame,startYear,outputFile)

## roxygen help ################################################################
#' Keyrun Simulated Catch to MSSPM Catch Conversion
#'
#' Conversion of Keyrun (i.e., Atlantis) Simulated Catch Index file to MSSPM Catch csv file
#' @param inputDataFrame The Keyrun input simulated catch data frame
#' @param startYear The year to start the conversion (earlier years will be skipped)
#' @param outputfile The output csv data file containing the MSSPM catch
#' formatted data. N.B. The csv file must begin with "HarvestCatch_".
#' @return n/a
#' @examples
#' remotes::install_github("NOAA-EDAB/ms-keyrun")
#'
#' inputDataFrame <- mskeyrun::simCatchIndex
#' startYear <- 55
#' outputFile <- '/home/rklasky/test/HarvestCatch_Keyrun_Simulated.csv'
#'
#' convertKeyrunCatchSimToMSSPM(inputDataFrame,startYear,outputFile)
#'

#' @export
convertKeyrunCatchSimToMSSPM <- function(inputDataFrame,startYear,outputFile) {

  # Get only the catch rows (i.e., no cv) and years >= the startYear
  simCatchData <- base::subset(inputDataFrame,year>=startYear & variable=='catch')

  # Keep only the columns MSSPM will need
  msspmColumns <- dplyr::select(simCatchData, year, Name, value)

  # Convert rows into columns
  msspmCatch <- tidyr::spread(msspmColumns, Name, value)

  # Write out final table
  readr::write_csv(msspmCatch,outputFile)

}

