# lib for samyok
library(jsonlite)
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