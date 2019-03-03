library(wordcloud)
library(RColorBrewer)
library(KoNLP)

newsList <- read.csv("./data/naverNewsCrawling.csv")

## 비슷한 유형의 기사내용만 추출
testData <- newsList$content[1:5]

## character형 변환
testData2 <- as.character(testData)

# 사전 추가
useSejongDic()

## 명사 추출
data <- sapply(testData2, extractNoun, USE.NAMES = F)

## 추출된 명사 벡터형으로
dataUnlist <- unlist(data)

## 한글 전처리
dataUnlist <- gsub('[~!@#$%&*()_+=?<>]', '', dataUnlist)
dataUnlist <- gsub("\\[", "", dataUnlist)
dataUnlist <- gsub('[ㄱ-ㅎ]', '', dataUnlist)
dataUnlist <- gsub("\\d+", "", dataUnlist)
dataUnlist <- gsub(" ", "", dataUnlist)
dataUnlist <- gsub("\\", "", dataUnlist)
dataUnlist <- gsub("\"", "", dataUnlist)

## table로 형변
wordcount <- table(dataUnlist)
wordcountTop <- head(sort(wordcount, decreasing = T), 100)


wordcloud(names(wordcountTop), wordcountTop)

color <- brewer.pal(12, "Set3")

wordcloud(names(wordcountTop), wordcountTop, scale=c(5,0.5),random.order = FALSE, random.color = TRUE, colors = color, family = "font")

display.brewer.all()

