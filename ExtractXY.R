ExtractXY<- function ( path.NLDAS, prjname, lxy, 
                      path.prj = file.path('./', prjname),
                      years=1979:2100){
    require(xts)
options(warn=-1)
path.prj = prjname
dir.create(file.path(path.prj), recursive=TRUE)
ncell = nrow(lxy);  # no of cells.
nmax = 464 * 224
cnames = paste0('x',lxy[,1], 'y',lxy[,2])
message(ncell,'grids')
print(lxy)
dirs = file.path(path.NLDAS,years)
dirs=dirs[which(file.exists(dirs))]
print(dirs)
ny = length(dirs)
flist = character();
for ( iy in 1:ny ){   #years
    celldata= lapply(cnames, FUN=as.null)
    names(celldata) = cnames
    ydir = dirs[iy]
    nc = nchar(ydir)
    year = substr(ydir, nc - 3, nc)
    message('\nReading year ... ', year);
    rds.list = list.files(pattern = '*-*.RDS$', path =ydir, recursive=TRUE, full.name=TRUE)
    nrds = length(rds.list)
    
    for (irds  in  1:nrds ){ # number of RDS, = julia day.
        rdsfn = rds.list[irds]
        message(irds, '/', nrds, '\t',year,'\t',basename(rdsfn))
        x=readRDS(rdsfn)
        nt = length(x)
        for (icell in 1:ncell){   #cells
            lx = lxy[icell, 1]
            ly = lxy[icell, 2]
            nv = dim(x[[1]]$data)[3];
            for (it in 1:nt){   # hours 
                tt = as.xts( matrix(x[[it]]$data[lx,ly,], ncol=nv), order.by=x[[it]]$time)
                if (it ==1){
                    mat=tt
                }else{
                    mat=rbind(mat, tt)
                }
            }
            colnames(mat) = names(x[[it]]$data[lx,ly,])
            celldata[[icell]]= rbind(celldata[[icell]], mat)
        }
    }
    fout = file.path(path.prj , paste0(prjname,'_',year, '_', nrds,'.RDS') )
    #prjname_year_#ofDays.RDS'
    flist[iy]=fout;
    message('\tExport to file:\t', fout);
    saveRDS(file = fout, celldata)
}

results<- flist
}
