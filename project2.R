#Copyright 2020. Taehyun Park. All Rights Reserved
#© 2020. Taehyun Park. All Rights Reserved
#Github. zjvlwndehr

init <-  function()
{
  install.packages("rvest")
  library(rvest) #html, xml crawling
  Sys.setenv(JAVA_HOME = "C:\\Program Files\\Java\\jdk-14.0.1")
  install.packages("rJava")
  library(rJava)

  remotes::install_github('SukjaeChoi/easySenti', upgrade="never", INSTALL_opts=c("--no-multiarch"), force = TRUE)
  remotes::install_github('SukjaeChoi/RHINO', upgrade="never", INSTALL_opts=c("--no-multiarch"), force = TRUE)
  remotes::install_github('haven-jeon/KoNLP', upgrade = "never", INSTALL_opts=c("--no-multiarch"), force = TRUE)
  install.packages("wordcloud")
  library(easySenti)
  library(RHINO)
  library(KoNLP)
  library(wordcloud)

  Filter <- function(args){
    args <- gsub('\n','', args)
    #args <- gsub(" ",'', args) #KoNLP cannot recognize each noun, unless we block this.
    args <- gsub('\'','', args)
    args <- gsub('  ','', args)
    args <- gsub('·','', args)
    args <- gsub('\\.','',args)
    args <- gsub(':','', args)
    args <- gsub('@','', args)
    args <- gsub('/','', args)
    args <- gsub('-','', args)
    args <- gsub('☎','', args)
    args <- gsub('▲','', args)
    args <- gsub('\\[.*?\\]', '', args)
    args <- gsub('\\(.*?\\)', '', args)
    args <- gsub('<.*?>', '', args)
    args <- gsub('[~!@#$%&*()_+=?<>]','', args)
  }

}
init()

text1 = ""

crawl <- function(){
  url <- "https://www.yna.co.kr/view/AKR20200922198300002"

  webpage <- xml2::read_html(url)

  title1 <- html_text(html_node(webpage, xpath='//*[@id="articleWrap"]/div[1]/header/h1'))  #Title of the news.
  title1

  text1 <- html_text(html_node(webpage, xpath='//*[@id="articleWrap"]/div[2]/div/div/div[1]'))  #Article of the news.
}
crawl()
text1 <- Filter(text1)
text1
clone_text = text1 # clone pure text

useSejongDic()
text1 <- extractNoun(text1)
text1 <- unlist(text1)
#text1 <- Filter(function(x){nchar(x)>=2}, text1) #Filtering
text1 <- Filter(function(x) {nchar(x) >=2}, text1)
text1 <- Filter(function(x){nchar(x)<9}, text1) #Filtering
text1

wordcount <- table(text1)
head(sort(wordcount, decreasing = T), 15)   #show 15nouns which are the most frequently used in the article.

wordcloud(words = text1,freq = wordcount
          ,min.freq = 2
          ,max.words = 300
          ,random.order = F
          ,rot.per = .1
          ,scale = c(4,0.3)
          ,random.color = TRUE
          ,family="headline")

setwd("D:\\RStudio\\regacy")
positive <- readLines("positive.txt")
negative <- readLines("negative.txt")
docs <- readLines("comments.txt")
docs <- Filter(docs)
docs
result <- easySenti(docs, positive, negative)
result
