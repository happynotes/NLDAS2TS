##########################################################################################
# Author: Lele Shu (lele.shu @ gmail)
# Purpose: Convert the RDS_yearly data to CSV table
##########################################################################################



require(xts)
library(foreach)
library(doMC)
library(rNOMADS)

path.RDS='./RDSout'
prjname = 'Example'

years=1979:1989;
lxy=t(matrix(c(424, 147,
               425, 147,
               424, 148,
               425, 148
      ), nrow=2 ))
colnames(lxy)=c('X','Y');

source('ExtractXY.R')
path.prj = file.path('./', prjname)

filelist <- ExtractXY(path.NLDAS = path.RDS, 
                      prjname=prjname, 
                      path.prj = path.prj,
                      lxy=lxy, years= years)

source('RDS2Table.R')
x=RDS2Table(years=years, path=path.prj )

SaveCSV(x=x, path=prjname)



