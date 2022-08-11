#
# Keyrun_ObsBM_to_MSSPM ######################################################
#
#
## Brief Description ###########################################################
# Script to convert Keyrun survey index file to MSSPM observed biomass file
#
#
## Detailed Description ########################################################
#
# This function takes the input keyrun survey biomass data frame,
# converts it to an MSSPM formatted data frame, and writes it out
# to the passed CSV file.
#
#
## Example Usage ###############################################################
#
# speciesMappingDataFrame <- mskeyrun::focalSpecies # needed to map SVSPP value to modelName
# observedBMDataFrame <- mskeyrun::surveyIndexA4
# surveySeason <- 'SPRING' # Use 'FALL' or "SPRING"
# outputFile <- paste('/home/rklasky/test/BiomassAbsolute_',surveySeason,'.csv',sep="")
# convertKeyrunObsBMtoMSSPM(speciesMappingDataFrame,observedBMDataFrame,surveySeason,outputFile)

## roxygen help ################################################################
#' Keyrun to MSSPM Biomass Conversion
#'
#' Conversion of Keyrun Survey Index file to MSSPM Observed Biomass csv file
#' @param speciesMappingDataFrame The data frame that contains a mapping of the SVSPP numeric values to corresponding species names (i.e., modelName)
#' @param observedBMDataFrame The input survey index (i.e. biomass) data frame
#' @param surveySeason The survey season data to convert (valid options are currently FALL or SPRING)
#' @param outputfile The output csv data file containing the MSSPM observed biomass
#' formatted data.  N.B. The csv file must begin with "Biomass".
#' @return n/a
#' @examples
#' remotes::install_github("NOAA-EDAB/ms-keyrun")
#'
#' speciesMappingDataFrame <- mskeyrun::focalSpecies # needed to map SVSPP value to modelName
#' observedBMDataFrame <- mskeyrun::surveyIndexA4
#' surveySeason <- 'SPRING' # Use 'FALL' or "SPRING"
#' outputFile <- paste('/home/rklasky/test/BiomassAbsolute_',surveySeason,'.csv',sep="")
#'
#' convertKeyrunObsBMtoMSSPM(speciesMappingDataFrame,observedBMDataFrame,surveySeason,outputFile)
#'
#' @export
convertKeyrunObsBMtoMSSPM <- function(speciesMappingDataFrame,observedBMDataFrame,surveySeason,outputFile) {

  # Grab the rows for the desired season and data type using the desired survey index data frame
  seasonData <- base::subset(observedBMDataFrame, SEASON==surveySeason & variable=='strat.biomass')

  # Grab just the columns needed for MSSPM
  seasonDataColumns <- dplyr::select(seasonData, YEAR, SVSPP, value)

  # Using the SVSPP-Name lookup data frame, replace the numeric SVSPP values with their modelName values
  seasonDataColumns$SVSPP <- base::with(speciesMappingDataFrame, modelName[match(seasonDataColumns$SVSPP,SVSPP)])

  # Rename the column header from SVSPP to Name
  names(seasonDataColumns)[names(seasonDataColumns) == "SVSPP"] <- "Name"

  # Create columns as species
  msspmObsBM <- tidyr::spread(seasonDataColumns, Name, value)

  # Write out final table
  readr::write_csv(msspmObsBM,outputFile)
}
