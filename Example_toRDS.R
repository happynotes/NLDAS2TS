##########################################################################################
# Requirement: wgrib or wgrib2 required.
# Author: Lele Shu (lele.shu @ gmail)
# Purpose: Read the NLDAS data in .GRB file to RDS file, in which data is
# organized in year. The program can use multiple cores to convert the GRB
# data.
##########################################################################################


rm(list=ls());
require(xts)
library(foreach)
library(doMC)
library(rNOMADS)
#years=1979:1980;
#ncores= 4
#path.Grib='/Volumes/backup/FORA'
#path.Temp='./gribTemp'
#path.RDS='./RDSout'
#source('read.grib.R')
source('read.grib.R')
Grib2RDS(years=1979:1980,
         ncores= 4,          #for parallel computing.
         path.Grib='./',
         path.Temp=file.path(path.Grib, 'gribTemp'), 
         path.RDS=path.Grib)


