source("~/R/debate-spyder/nsda.R")

library(xtable)
# log = NSDAlogin("nepalsamyok@gmail.com", "AbeLincoln", "cookies/3")
s = NSDASearch("Bidhi Kasu", cookies = "cookies/1")
x = NSDAMember(s[1,1],cookies="cookies/1")
