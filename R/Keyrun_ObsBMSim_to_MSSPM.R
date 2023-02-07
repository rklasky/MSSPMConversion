#
# Keyrun_ObsBMSim_to_MSSPM ######################################################
#
#
## Brief Description ###########################################################
# Script to convert Keyrun survey index simulation file to MSSPM observed biomass file
#
#
## Detailed Description ########################################################
#
# This function takes the input keyrun simulation survey biomass data frame,
# converts it to an MSSPM formatted data frame, and writes it out
# to the passed CSV file.
#
#
## Example Usage ###############################################################
#
# observedBMSimDataFrame <- mskeyrun::simSurveyIndex
# surveySeason <- 'FALL' # Use 'FALL' or "SPRING"
# outputFile <- paste('/home/rklasky/test/BiomassAbsolute_Sim',surveySeason,'.csv',sep="")
# convertKeyrunObsBMSimtoMSSPM(observedBMDataFrame,surveySeason,outputFile)

## roxygen help ################################################################
#' Keyrun to MSSPM Sim Biomass Conversion
#'
#' Conversion of Keyrun Simulated Survey Index file to MSSPM Observed Biomass csv file
#' @param observedBMDataFrame The input simulated survey index (i.e. biomass) data frame
#' @param surveySeason The survey season data to convert (valid options are currently FALL or SPRING)
#' @param outputfile The output csv data file containing the MSSPM observed biomass
#' formatted data.  N.B. The csv file must begin with "BiomassAbsolute_".
#' @return n/a
#' @examples
#' remotes::install_github("NOAA-EDAB/ms-keyrun")
#'
#' observedBMSimDataFrame <- mskeyrun::simSurveyIndex
#' surveySeason <- 'FALL' # Use 'FALL' or "SPRING"
#' outputFile <- paste('/home/rklasky/test/BiomassAbsolute_Sim',surveySeason,'.csv',sep="")
#'
#' convertKeyrunObsBMSimtoMSSPM(observedBMSimDataFrame,surveySeason,outputFile)
#'
#' @export
convertKeyrunObsBMSimtoMSSPM <- function(observedBMSimDataFrame,surveySeason,outputFile) {
	
  # Format the surveyName field properly based upon the season (Fall or Spring)
  surveyName <- paste("BTS_",tolower(surveySeason),"_allbox_effic1",sep="") 

  # Grab the rows for the desired season and data type using the desired survey index data frame
  seasonData <- base::subset(observedBMSimDataFrame, survey==surveyName & variable=='biomass')

  # Grab just the columns needed for MSSPM
  seasonDataColumns <- dplyr::select(seasonData, year, Name, value)

  # Create columns as species
  msspmObsBMSim <- tidyr::spread(seasonDataColumns, Name, value)

  # Write out final table
  readr::write_csv(msspmObsBMSim,outputFile)
}
