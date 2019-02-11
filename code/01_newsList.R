library(rvest)
library(dplyr)

newUrl <- "https://news.naver.com/main/main.nhn?mode=LSD&mid=shm&sid1=100"

listHtml <- read_html(newUrl)

headLines <- listHtml %>% 
  html_nodes("._persist") %>%
  html_nodes(".cluster")

for(line in headLines) {
  subUrl <- line %>% html_nodes(".cluster_text a") %>% html_attr("href")
  
  ## print(line)
  print(subUrl)
}

newsList <- listHtml %>% 
  html_nodes("#section_body") %>%
  html_node("ul")
