#
# Keyrun_CatchAtAge_to_MSCAA #######################################
#
#
## Brief Description ###########################################################
# Script to convert the Commercial AgeComp catch file to an MSCAA catch at age
# file for a particular species
#
#
## Detailed Description ########################################################
#
# This function takes the input catch at age file, converts it
# to an MSCAA formatted data frame, and writes it out to the passed
# CSV file.
#
#
## Example Usage ###############################################################
#
# inputDataFrame <- mskeyrun::realFisheryAgecomp
# species <- "Atlantic cod"
# startYear <- 55
# outputFile <- '/home/rklasky/test/HarvestCatch_Keyrun.csv'
# convertKeyrunCatchCommercialAgeCompToMSSPM(inputDataFrame,startYear,outputFile)

## roxygen help ################################################################
#' Keyrun Commercial Catch at Age to MSCAA Catch Conversion
#'
#' Conversion of Keyrun Catch at Age data file to MSCAA Catch csv file
#' @param inputDataFrame The Keyrun input fishery catch data frame
#' @param startYear The year to start the conversion (earlier years will be skipped)
#' @param outputfile The output csv data file containing the MSCAA catch data
#' @return n/a
#' @examples
#' remotes::install_github("NOAA-EDAB/ms-keyrun")
#'
#' inputDataFrame <- mskeyrun::realFisheryAgecomp
#' species <- "Atlantic cod"
#' startYear <- 1968
#' fishery <- "demersal"
#' outputFile <- '/home/rklasky/test/Keyrun_CatchAtAge_Atlantic_Cod.csv'
#'
#' convertKeyrunCatchAtAgeToMSCAA(inputDataFrame,species,startYear,fishery,outputFile)
#'

#' @export
convertKeyrunCatchAtAgeToMSCAA <- function(inputDataFrame,speciesName,startYear,fisheryType,outputFile) {

  # Get only the desired catch rows
  fisheryCatchData <- base::subset(inputDataFrame,Name==speciesName & year>=startYear & fishery==fisheryType)

  # Keep only the columns MSSPM will need
  mscaaColumns <- dplyr::select(fisheryCatchData, year, age, value)
  sortedColumns <- mscaaColumns[with(mscaaColumns,order(year,age)),]

  # Convert rows into columns
  mscaaCatch <- tidyr::spread(sortedColumns, age, value)

  # Write out final table
  readr::write_csv(mscaaCatch,outputFile)

}

