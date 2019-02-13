library(rvest)
library(dplyr)

## 100 : 정치
## 101 : 경제
## 102 : 사회
## 103 : 생활/문화
## 104 : 세계
## 105 : IT/과학

## 헤드라인 뉴스 목록 크롤링
newsDf <- data.frame(subject=NA, url=NA)

for(i in 100:105) {
  mainUrl <- paste0("https://news.naver.com/main/main.nhn?mode=LSD&mid=shm&sid1=", toString(i))
  print(mainUrl)
 
  listHtml <- read_html(mainUrl)
  
  headLines <- listHtml %>% 
               html_nodes("._persist") %>%
               html_nodes(".cluster") %>%
               html_nodes(".cluster_group")
  
  for(line in headLines) {
    subUrl <- line %>% html_nodes(".cluster_text a") %>% html_attr("href")
    print(subUrl)
    
    temp <- cbind(subject=i, url=subUrl)
    newsDf <- rbind(newsDf, temp)
  }
}

newsDf <- newsDf %>% filter(!is.na(subject))                              # 결측치 제거

write.csv(newsDf, file="./data/headLineList.csv", row.names = FALSE)      # csv 파일 생성

####################################################################################################

## 뉴스 목록 크롤링
newsURL <- "https://news.naver.com/main/main.nhn?mode=LSD&mid=shm&sid1=105"
newsHtml <- read_html(newsURL)

newsList <- newsHtml %>% html_nodes("#main_content") %>% html_nodes("#section_body") %>% html_node("ul")
