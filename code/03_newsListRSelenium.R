library(RSelenium)
library(rvest)

remoteDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, browserName = "chrome")
remoteDr$open() 
remoteDr$navigate("https://news.naver.com/main/main.nhn?mode=LSD&mid=shm&sid1=105")

htmlFull <- remoteDr$getPageSource()[[1]]

html <- read_html(htmlFull)

newsList <- html %>% html_nodes("#section_body ul")

for(one in newsList) {
  
  ## news click href 
  temp <- one %>% html_nodes("li dl dt") %>% html_nodes("a") %>% html_attr("href")
  
  print(temp) 
}

print(newsList)


