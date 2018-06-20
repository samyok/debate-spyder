# lib for samyok
CURL_DIR = paste('"',getwd(), '/curl/bin/curl"', sep='')
setCurlDir = function(string){
  CURL_DIR = string
  return()
}
concat = function(...){
  return(paste(...,sep=''))
}
SCurl = function(url, POST=FALSE, data=NULL, cookies="nsda.cookies"){
  if(POST){
    rslt=system(concat(CURL_DIR, ' -s -c ',cookies,' -d ',data, ' -X POST ', url), intern = TRUE)
  } else {
    rslt=system(concat(CURL_DIR, ' -s -c ',cookies,' ', url), intern = TRUE)
  }
  return(rslt)
} 
NSDAlogin = function(user, pass, cookies) {
  loginName=URLencode(user)
  pwd = URLencode(pass)
  data = concat('"log=',loginName,'&pwd=',password,'&wp-submit=Log+In&redirect_to=%2Faccount&testcookie=1"')
  return(SCurl("https://www.speechanddebate.org/wp-login.php", POST=TRUE, data=data, cookies=cookies))
}
########################
########################
########################

username = "nepalsamyok@gmail.com"
password = "AbeLincoln" # for NSDA

NSDAlogin(user=username, pass=password, cookies="nsda.cookies")

person_to_search = "Samyok Nepal"

person = URLencode(person_to_search)
url= concat("https://api.speechanddebate.org/v1/search?q=", person_to_search)
search = SCurl(url, cookies="nsda.cookies")
# results = system(search, intern = TRUE)
# #thingC:/Users/SSO103/Downloads/curl-7.60.0-win32-mingw/bin>curl 
# library(jsonlite)
# mydf <- fromJSON(results)
# mydf[1,1] # id of first result
