## Description
This package contains R scripts that convert Keyrun data to MSSPM data. The convertKeyrun functions convert either catch data (simulated or commercial) to an MSSPM-readable CSV file or survey index biomass data to an MSSPM-readable CSV file. The convertEcodata function converts Ecodata data to Covariate data written to an MSSPM-readable CSV file.

## Installation
``` r
remotes::install_github("rklasky/MSSPMConversion")
``` 

## Example Usage
``` r
# Make sure the keyrun package has been loaded
remotes::install_github("NOAA-EDAB/ms-keyrun")

# Set initial values for function arguments
# N.B. CSV filename must begin with "HarvestCatch_"
inputDataFrame <- mskeyrun::simCatchIndex
startYear <- 55
outputFile <- '<user directory>/HarvestCatch_Keyrun_Simulated.csv'

# Call function to convert Keyrun Catch sim data to an MSSPM-readable CSV file
convertKeyrunCatchSimToMSSPM(inputDataFrame,startYear,outputFile)
```

## Legal disclaimer
*This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is provided on an ‘as is’ basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.*
