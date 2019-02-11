library(rvest)
library(dplyr)

testUrl <- "https://news.naver.com/main/read.nhn?mode=LSD&mid=shm&sid1=101&oid=011&aid=0003501547"

html <- read_html(testUrl)

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

oneNews <- cbind(url=testUrl, title=atTitle, company=atCompanyName, time=atWriteTime, content=atContent)

dfNews <- as.data.frame(oneNews)
