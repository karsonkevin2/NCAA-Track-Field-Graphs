rm(list=ls())

library(rvest)
library(ggplot2)
library(dplyr)

#Table numer, 1=men100 2=women100 3=men200 ... etc
eventNumber = 9

#Could scrape from web, but ToS says not to. Instead download local copy of pages
#page = read_html("https://www.tfrrs.org/lists/2568.html?limit=%3C%3D500&event_type=all&year=&gender=x")

#list of local or web .html files
pages = c("C:/Users/karso/Documents/School2021/Research/TFRRS_2012.html",
          "C:/Users/karso/Documents/School2021/Research/TFRRS_2013.html",
          "C:/Users/karso/Documents/School2021/Research/TFRRS_2014.html",
          "C:/Users/karso/Documents/School2021/Research/TFRRS_2015.html",
          "C:/Users/karso/Documents/School2021/Research/TFRRS_2016.html",
          "C:/Users/karso/Documents/School2021/Research/TFRRS_2017.html",
          "C:/Users/karso/Documents/School2021/Research/TFRRS_2018.html",
          "C:/Users/karso/Documents/School2021/Research/TFRRS_2019.html",
          "C:/Users/karso/Documents/School2021/Research/TFRRS_2021.html")

#output data frame
data_concat = data.frame(
  PLACE=integer(), 
  TIME=double(), 
  YEAR=factor()
)

#extract data from each page
for (page in pages) {
  print(page)

  tfrrs = paste(readLines(page), collapse="\n")
  tfrrs = read_html(tfrrs)
  
  tables = html_nodes(tfrrs, "table")
  
  data = html_table(tables[[eventNumber]])
  names(data)[1] = "PLACE"
  
  data = data[, c("PLACE", "TIME")]
  
  #Remove altitude conversion and 1 mile conversion notation
  data$TIME = sub("@", "", data$TIME)
  data$TIME = sub("\\(1\\)", "", data$TIME)
  
  #convert mm:ss.00 to a number
  a = regexpr(":", data$TIME)
  
  data$TIME = with(data, 
       ifelse(a == -1, as.numeric(TIME),
              as.numeric(substr(TIME, 0, a-1)) * 60 + 
                as.numeric(substr(TIME, a+1, length(TIME)))))

  #tack on the year
  YEAR = substr(html_text(html_node(tfrrs, "h3")), 0, 4)
  data$YEAR = YEAR
  factor(data$YEAR)
  
  #add to output
  data_concat = rbind(data_concat, data)
}

#create plot
mydata = data_concat
ggplot(data=mydata, aes(x=PLACE, y=TIME, group=YEAR)) + 
  geom_line(data = filter(mydata, YEAR=="2021"), size=2) +
  geom_line(aes(color=YEAR)) + 
  ggtitle("NCAA D1 Men's 100m")
