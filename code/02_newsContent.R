library(rvest)
library(dplyr)

newsList <- read.csv("./data/headLineList.csv")

newsConDf <- data.frame(url=NA, title=NA, company=NA, time=NA, content=NA)

for(one in newsList$url) {
  
  subUrl <- one
  html <- read_html(subUrl)
  
  articleInfo <- html %>% 
    html_nodes(".article_header") %>% 
    html_nodes(".article_info")
  
  articleCompany <- unique(html %>% 
                           html_nodes(".article_header") %>%
                           html_nodes(".press_logo a img") %>%
                           html_attrs())
  
  atCompanyName <- articleCompany[[1]][["alt"]]
  
  atTitle <- unique(articleInfo %>% 
                      html_nodes("#articleTitle") %>%
                      html_text())
  
  atWriteTime <- unique(articleInfo %>% 
                          html_nodes(".t11") %>%
                          html_text())
  
  if(length(atWriteTime) > 1) {                        ## 기사 입력시간과 기사 수정시간이 있을 경우에 최종 수정시간으로
    atWriteTime <- atWriteTime[length(atWriteTime)]
  }
  
  articleContent <- html %>%
    html_nodes("#articleBody") %>%
    html_nodes("#articleBodyContents")
  
  atContent <- unique(articleContent %>% html_text())
  
  atContent <- gsub("flash 오류를 우회하기 위한 함수 추가", "", atContent)
  atContent <- gsub("function _flash_removeCallback", "", atContent)
  atContent <- gsub("\n", "", atContent)
  atContent <- gsub("\t", "", atContent)
  atContent <- gsub("\\(\\)", "", atContent)
  atContent <- gsub("\\{\\}", "", atContent)
  
  oneNews <- cbind(url=subUrl, title=atTitle, company=atCompanyName, time=atWriteTime, content=atContent)
  
  newsConDf <- rbind(newsConDf, oneNews)
}

newsConDf <- newsConDf %>% filter(!is.na(url))                                # 결측치 제거

write.csv(newsConDf, file="./data/naverNewsCrawling.csv", row.names = FALSE)      # csv 파일 생성
