username = "nepalsamyok@gmail.com"
password = "AbeLincoln" # for NSDA
loginName=URLencode(username)
pwd = URLencode(password)

curl = "C:/Users/SSO103/Downloads/curl-7.60.0-win32-mingw/bin/curl -s " 

base_url= '"https://api.speechanddebate.org/v1/'

thing = system(paste('C:/Users/SSO103/Downloads/curl-7.60.0-win32-mingw/bin/curl -s -c nsda.cookies -d "log=',loginName,'&pwd=',password,'&wp-submit=Log+In&redirect_to=%2Faccount&testcookie=1" -X POST https://www.speechanddebate.org/wp-login.php'))

person_to_search = "Samyok Nepal"

person = URLencode(person_to_search)
search = (paste(curl, base_url, 'search?q=', person, '" -b nsda.cookies', sep=''))
results = system(search, intern = TRUE)
#thingC:/Users/SSO103/Downloads/curl-7.60.0-win32-mingw/bin>curl 
library(jsonlite)
mydf <- fromJSON(results)
mydf[1,1] # id of first result