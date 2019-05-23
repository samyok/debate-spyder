# lib for samyok
library(jsonlite)
library(readr)

CURL_DIR = paste('curl', sep = '')
concat = function(...) {
  return(paste(..., sep = ''))
} ## WORKS
SCurl = function(url, POST = FALSE, data = NULL, cookies = "nsda.cookies") {
  if (POST) {
    rslt = system(concat(CURL_DIR, ' -s -b ', cookies, ' -d ', data, ' -X POST ', url),
                  intern = TRUE)
    print(s)
  } else {
    rslt = system(concat(CURL_DIR, ' -s -b ', cookies, ' ', url), intern = TRUE)
  }
  return(rslt)
} ## WORKS
NSDAlogin = function(user, pass, cookies) { #### WORKS
  loginName = URLencode(user, reserved =TRUE)
  pwd = URLencode(pass, reserved =TRUE)
  thing = system(
    concat(
      'curl -s -c "',
      cookies,
      '" -d "log=',
      loginName,
      '&pwd=',
      pwd,
      '&wp-submit=Log+In&redirect_to=%2Faccount&testcookie=1" -X POST https://www.speechanddebate.org/wp-login.php'
    ))
  test_search = fromJSON(SCurl(url="https://api.speechanddebate.org/v1/search?q=0", cookies = cookies))
  return(is.data.frame(test_search))
} ## WORKS

## EVERYTHING ABOVE WORKS
## SAMYOK 6/20/18 21:23 CST

NSDASearch = function(name, cookies = "nsda.cookies", type = "member" ) {
  nam = URLencode(name, reserved = FALSE)  
  results = fromJSON(SCurl(concat("https://api.speechanddebate.org/v1/search?q=",nam), cookies, POST = FALSE))
  final = data.frame("id"=1, "name"="[[NO RESULTS]]", "type"='member', stringsAsFactors = FALSE)
  index = 1
  for(i in 1:length(results[,1])){
    if(results[i,]$type == type){
      final[index, ] = results[i,]
      index <- index + 1 
    }
  }
  return(final)
}
NSDAMember <-  function(id, cookies="nsda.cookies") {
  x = fromJSON(SCurl(concat("https://api.speechanddebate.org/v1/members/",id), cookies, POST = FALSE))
  backlist = c("degrees", "honors", "citations", "timestamp")
  for(i in 1:length(backlist)){
    x[backlist[i]] = NULL
  }
  # xtable(data.frame((x)))
  
  lname <- names(x)
  y <- data.frame()
  # names(y) <- lname
  z <- c()
  for(i in 1:length(lname)){
    if(is.null(x[[i]] )){
      z[i] <- ""
    } else {
      z[i] <- (x[[i]])
    }
    
  }
  
  mx = matrix(z, nrow = 1, ncol = 22)
  df = as.data.frame(mx)
  names(df) <- lname
  return(df)
}
NSDAPoints <- function(id, cookies = "nsda.cookies"){
  x = fromJSON(SCurl(concat("https://api.speechanddebate.org/v1/members/",id, "/points"), cookies, POST = FALSE))
  return(x)
}
NSDAGetCompPoints <- function(arr, competition_type){
  z = data.frame()
  
  for(i in 1:nrow(x)){
    if(x[i,'category'] == competition_type){
      z = rbind(z, x[i,])
    }
  }
  return(z)
}
NSDANumWins = function(y){
  result = 0
  for(i in 1:nrow(y)){
    result = result + as.numeric(strsplit(y[i, 'result'], "W")[[1]][1])
  }
  return(result)
}
NSDANumLosses = function(y){
  result = 0
  for(i in 1:nrow(y)){
    result = result + as.numeric(strsplit(strsplit(y[i, 'result'], "W, ")[[1]][2], "L")[[1]][1])
  }
  return(result)
}

NSDAEarliestYear = function(y) {
  result = 999999
  for(i in 1:nrow(y)){
    year = as.numeric(strsplit(y[i, 'tourn_start'], "-")[[1]][1])
    if( year < result) {
      result = year  
    }
  }
  return(result)
}
NSDANumNats  =function(y){
  result = 0
  for(i in 1:nrow(y)){
    if(y[i, 'nationals']){
      result = result +1 
    }
  }
  return(result)
}
NSDANatsPts = function(y){
  result = 0
  for(i in 1:nrow(y)){
    if(y[i, 'nationals']){
      result = result + y[i, 'points']
    }
  }
  return(result)
}
NSDAthreatScore = function(x, member){
  y = NSDAGetCompPoints(x, 103)
  points = sum(y['points'])
  
  summy = NSDANumWins(y)
  lossy = NSDANumLosses(y)
  
  years = NSDAEarliestYear(y) - as.numeric(format(Sys.Date(), "%Y"))
  nationals = NSDANumNats(y)
  ptsNats = NSDANatsPts(y)
  
  if(is.null(member[1, 'points_last_year'])){
    ptsLastYear = 0
  } else {
    ptsLastYear =as.numeric(as.character( member[1, 'points_last_year']))
  }
  ptsThisYear = as.numeric(as.character(member[1, 'points_this_year']))
  totalPoints = as.numeric(as.character(as.numeric(member[1, 6])))
  
  threat_score = points/10 + totalPoints/20+ ptsThisYear/10 + years*50 + summy*2 + summy * 20 / (lossy +1 ) + nrow(x) + nationals*50 + ptsNats/5
}
