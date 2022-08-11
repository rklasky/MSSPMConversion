#
# Keyrun_CatchCommercialAgeComp_to_MSSPM #######################################
#
#
## Brief Description ###########################################################
# Script to convert the Commercial AgeComp catch file to an MSSPM catch file
#
#
## Detailed Description ########################################################
#
# This function takes the input Commercial AgeComp catch file, converts it
# to an MSSPM formatted data frame, and writes it out to the passed
# CSV file.
#
#
## Example Usage ###############################################################
#
# inputDataFrame <- mskeyrun::realFisheryAgecomp
# startYear <- 55
# outputFile <- '/home/rklasky/test/HarvestCatch_Keyrun.csv'
# convertKeyrunCatchCommercialAgeCompToMSSPM(inputDataFrame,startYear,outputFile)

## roxygen help ################################################################
#' Keyrun Commercial AgeComp Catch to MSSPM Catch Conversion
#'
#' Conversion of Keyrun Commercial AgeComp Catch data file to MSSPM Catch csv file
#' @param inputDataFrame The Keyrun input fishery catch data frame
#' @param startYear The year to start the conversion (earlier years will be skipped)
#' @param outputfile The output csv data file containing the MSSPM catch
#' formatted data. N.B. The csv file must begin with "HarvestCatch_".
#' @return n/a
#' @examples
#' remotes::install_github("NOAA-EDAB/ms-keyrun")
#'
#' inputDataFrame <- mskeyrun::realFisheryAgecomp
#' startYear <- 55
#' outputFile <- '/home/rklasky/test/HarvestCatch_Keyrun_AgeComp.csv'
#'
#' convertKeyrunCatchCommercialAgeCompToMSSPM(inputDataFrame,startYear,outputFile)
#'

#' @export
convertKeyrunCatchCommercialAgeCompToMSSPM <- function(inputDataFrame,startYear,outputFile) {

  # Get only the catch rows (i.e., no cv) and years >= the startYear
  fisheryCatchData <- base::subset(inputDataFrame,year>=startYear & variable=='catch')

  # Keep only the columns MSSPM will need
  msspmColumns <- dplyr::select(fisheryCatchData, year, Name, value)

  # Convert rows into columns
  msspmCatch <- tidyr::spread(msspmColumns, Name, value)

  # Write out final table
  readr::write_csv(msspmCatch,outputFile)

}

