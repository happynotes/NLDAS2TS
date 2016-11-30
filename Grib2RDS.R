Grib2RDS <- function(years=1979:1980, ncores= 4, 
                     path.Grib='./',
                     path.Temp=file.path(path.Grib, 'gribTemp'), 
                     path.RDS=path.Grib){
#rm(list=ls());
#years=1979:1980;
#ncores= 4
#path.Grib='/Volumes/backup/FORA'
#path.Temp='./gribTemp'
#path.RDS='./RDSout'
#source('read.grib.R')
#i=1
library(foreach)
library(doMC)
library(rNOMADS)
#remove non-exist year-folder.
#eid = dir.exists(tmpdir)
#nyears =    years[eid]
#ydirs = tmpdir[eid]

#number of Cores for parallel.
ny=length(years)
if (ny != length(years) ){
    warning('Input Years are',paste(years))
    warning('Exist Years are',paste(nyears))
}
nc= min(ny, ncores)
message('\nNumber of Cores = ', nc);
registerDoMC(ncores)  #change the # to your number of CPU cores 

if(!dir.exists(path.RDS)){
    dir.create(path.RDS, recursive=TRUE,     showWarnings=TRUE)
}
if(!dir.exists(path.Temp)){
    dir.create(path.Temp, recursive=TRUE,     showWarnings=TRUE)
}

x= foreach ( i = 1:ny ) %do% {
    year = years[i]
    ydir = file.path(path.Grib, year)
    message('\nReading year ... ', year);
    jddirs  = list.dirs(ydir,recursive=FALSE, full.names=TRUE)


    outdir = file.path(path.RDS, year);
        if(!dir.exists(outdir)){
            dir.create(outdir, recursive=TRUE,     showWarnings=TRUE)
        }

    tmpfile = file.path(path.Temp, 
                            paste0('.TMP_year', year,'_core',i,'_',round(abs(rnorm(1)*1e4) ), '.tmp') )
    for (jdir in jddirs){
        files = list.files(path = jdir , recursive = TRUE, pattern = ".grb$", full.names=TRUE)
        nf = length(files)
        ydat = list(nf);
        nc = nchar(jdir)
        jday = substr(jdir, nc - 2, nc)
        message('\n\tJday = ', jday) 
        for ( i in  1:nf){
            fn = files[i]
            x=read.grib(fn = fn, tmpfile=tmpfile)
            message(i,'/', nf, "\t", fn,"\t", x$time);
            ydat[[i]] = x;
        }
        fn.rds= paste0(year, '-', jday, '.RDS');
        rds.name =  file.path(outdir, fn.rds) 
        saveRDS(file = rds.name, ydat)
        message('Save to RDS', rds.name);
    }
    file.remove(tmpfile)
}

}



