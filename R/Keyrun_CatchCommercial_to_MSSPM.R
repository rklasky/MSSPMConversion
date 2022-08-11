#
# Keyrun_CatchCommercial_to_MSSPM ##############################################
#
#
## Brief Description ###########################################################
# Script to convert Keyrun Commercial Catch file to MSSPM Catch file
#
#
## Detailed Description ########################################################
#
# This function takes the input keyrun commercial catch (i.e., landings) data frame,
# converts it to an MSSPM formatted data frame, and writes it out
# to the passed CSV file.
#
#
## Example Usage ###############################################################
#
# speciesMappingDataFrame <- mskeyrun::focalSpecies # needed to map NESPP3 value to modelName
# observedBMDataFrame <- mskeyrun::catchIndex
# outputFile <- paste('/home/rklasky/test/HarvestCatch_Keyrun_Commercial.csv')
# convertKeyrunCatchCommercialToMSSPM(speciesMappingDataFrame,catchIndexDataFrame,outputFile)

## roxygen help ################################################################
#' Keyrun to MSSPM Biomass Conversion
#'
#' Conversion of Keyrun Commercial Catch Index file to MSSPM Catch csv file
#' @param speciesMappingDataFrame The data frame that contains a mapping of the NESPP3 numeric values to corresponding species names (i.e., modelName)
#' @param catchIndexDataFrame The input commercial catch index (i.e. commercial landings in metric tons) data frame
#' @param outputfile The output csv data file containing the MSSPM catch data
#' formatted data.  N.B. The csv file must begin with "HarvestCatch_".
#' @return n/a
#' @examples
#' remotes::install_github("NOAA-EDAB/ms-keyrun")
#'
#' speciesMappingDataFrame <- mskeyrun::focalSpecies # needed to map NESPP3 value to modelName
#' speciesMappingDataFrame$NESPP3 <- as.numeric(speciesMappingDataFrame$NESPP3) # necessary to eliminate the leading 0's in the NESPP3 terms
#'
#' #load(file='/home/rklasky/Downloads/catchIndex.rda') # temporary until the data are released into mskeyrun
#' catchIndex <- mskeyrun::catchIndex
#'
#' outputFile <- '/home/rklasky/test/CatchCommercial.csv'
#'
#' convertKeyrunCatchCommercialToMSSPM(speciesMappingDataFrame,catchIndex,outputFile)
#'
#' @export
convertKeyrunCatchCommercialToMSSPM <- function(speciesMappingDataFrame,catchIndex,outputFile) {

  # Grab the columns needed or MSSPM
  catchColumns <- dplyr::select(catchIndex, YEAR, NESPP3, value)

  # Using the NESPP3-Name lookup data frame, replace the numeric NESPP3 values with their modelName values
  catchColumns$NESPP3 <- base::with(speciesMappingDataFrame, modelName[match(catchColumns$NESPP3,NESPP3)])

  # Rename the column header from NESPP3 to Name
  names(catchColumns)[names(catchColumns) == "NESPP3"] <- "Name"

  # Keep only the columns MSSPM will need
  msspmColumns <- dplyr::select(catchColumns, YEAR, Name, value)

  # Create columns as species
  msspmCatchCommercial <- tidyr::spread(msspmColumns, Name, value)

  # Write out final table
  readr::write_csv(msspmCatchCommercial,outputFile)
}
