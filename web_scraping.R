rm(list=ls())
library(xlsx)
library(rvest)

#Read all the given urls
et <- read.xlsx("ET_Links_Sample.xlsx",sheetIndex = 1,header = F)
et[,1]=as.character(et[,1])
str(et)

#initializations
title=c()
body=c()
date=c()
n=1

#provide url to read_html function

for(i in 1:nrow(et)){
  url=read_html(et[i,1])

  #get hrefs of all the links in provided url
  hrefs <- url%>%html_nodes("ul.content li a")%>%html_attr("href")
  hrefs    #returns vector of partial urls
  date.et <- url%>%html_nodes("td.contentbox5 b")%>%html_text()
  
  for(j in 1:length(hrefs)){
  #append title to get complete url
  appended.url=paste("http://economictimes.indiatimes.com",hrefs[j],sep = '')
  link=read_html(appended.url)
  
  #Get title, body and date from the article
  title[n] <- link%>%html_nodes("h1.title")%>%html_text() 
  
  body[n] <- link%>%html_nodes("div.Normal")%>%html_text()
  
  date[n] <- date.et[2]
  n=n+1
  }
}


final=as.data.frame(cbind(date,title,body))

write.xlsx(final,"final.xlsx")


