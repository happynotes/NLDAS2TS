year2list <-function( years= 1979:2015, path='./'){
ny=    length(years)
for (i in 1:ny){
    yr = years[i]
    message(i,'/', ny,'\t', yr)
    fn = list.files(pattern = paste0('*',yr,'.RDS$'), path =path, recursive=FALSE, full.name=TRUE) 
    if (!file.exists(fn)){
        warning('missing')    
    }
    x=readRDS(fn)

    if(i==1){
        y=x;
        n = length(y)
    } else{

        for( j in 1:n){
            y[[j]] = rbind(y[[j]], x[[j]])
        }
    }
}
    result <- y;
}


