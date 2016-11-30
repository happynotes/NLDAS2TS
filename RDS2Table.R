RDS2Table <-function( path,
                     years= 1979:2015                      
                     ){
ny=    length(years)
for (i in 1:ny){
    year = years[i]
    message(i,'/', ny,'\t', year)
    fn = list.files(path=path, pattern = glob2rx( paste0('*', year, '*.RDS')),
                    full.names=TRUE);
    if (length(fn)<=0){
        message('\tData is missing in ', year);    
        next ;
    }
    x=readRDS(fn)

    if(i==1){
        y=x;
        nlist = length(y)
    } else{

        for( j in 1:nlist){
            y[[j]] = rbind(y[[j]], x[[j]])
        }
    }
}
    result <- y;
}

SaveCSV <- function (x, path='./'){
    require(xts)
nsites = length(x)
vnames = names(x)
fs = file.path(path, paste0(vnames, '.csv'))
message('Writing csv out ... ')
for (i in 1:nsites){  
    message('\t', i,'/', nsites,'\t', fs[i])
    write.zoo(x=x[[i]], index.name='TIME',row.names=FALSE, col.names=TRUE, file=fs[i])  
}
}



