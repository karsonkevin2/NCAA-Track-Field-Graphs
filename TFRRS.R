rm(list=ls())

library(rvest)
library(ggplot2)
library(dplyr)

#Table numer, 1=men100 2=women100 3=men200 ... etc
eventNumber = 9

#Could scrape from web, but ToS says not to. Instead download local copy of pages
#page = read_html("https://www.tfrrs.org/lists/2568.html?limit=%3C%3D500&event_type=all&year=&gender=x")

#list of local or web .html files
pages = c("C:/Users/karso/Documents/School2021/TFRRS/TFRRS_2012.html",
          "C:/Users/karso/Documents/School2021/TFRRS/TFRRS_2013.html",
          "C:/Users/karso/Documents/School2021/TFRRS/TFRRS_2014.html",
          "C:/Users/karso/Documents/School2021/TFRRS/TFRRS_2015.html",
          "C:/Users/karso/Documents/School2021/TFRRS/TFRRS_2016.html",
          "C:/Users/karso/Documents/School2021/TFRRS/TFRRS_2017.html",
          "C:/Users/karso/Documents/School2021/TFRRS/TFRRS_2018.html",
          "C:/Users/karso/Documents/School2021/TFRRS/TFRRS_2019.html",
          "C:/Users/karso/Documents/School2021/TFRRS/TFRRS_2021.html")

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

data_concat_save = data_concat



#create plot
mydata = data_concat
ggplot(data=mydata, aes(x=PLACE, y=TIME, group=YEAR)) + 
  #geom_line(data = filter(mydata, YEAR=="2021"), size=2) +
  geom_line(aes(color=YEAR)) + 
  ggtitle("NCAA D1 Men's 5000m")



#NEW STUFF
library(plyr)
library(zoo)

#                       1      2       3     4       5      6      7     8      9
data_concat$PLACE = c(1:500, 1:500, 1:500, 1:500, 1:500, 1:500, 1:500, 1:500, 1:500)

#create dummy set because of ties
mydata3 = data
mydata3 = subset(mydata3, select = -c(YEAR))
mydata3$TIME = NA
mydata3$PLACE = 1:500

#get average of pre2021
mydata2 = data_concat
mydata2 = filter(mydata2, YEAR!="2021")
mydata2 = subset(mydata2, select= -c(YEAR))
mydata2 = arrange(mydata2, TIME)
#medianish = mydata2$TIME[seq(4, length(mydata2$TIME), 8)]
mydata2 = ddply(mydata2, .(PLACE), summarize, TIME = mean(TIME))
#fill dummy set
mydata3$TIME[mydata2$PLACE] = mydata2$TIME
mydata2 = mydata3
mydata2 = na.locf(mydata2)

#comment out, using overall placement average or per year average
#mydata2$TIME = medianish


#adjust number to change averaging window,
#   shouldn't need to be very high
window = 7
mydata2$TIME2 = rollmean(mydata2$TIME, window, na.pad=TRUE)
#mydata2$TIME2[1:2] = mydata2$TIME[1:2]
mydata2$TIME2[1:(window-1)/2] = mydata2$TIME[1:(window-1)/2]
#mydata2$TIME2[499:500] = mydata2$TIME[499:500]
windowH = 500 - (window-1)/2 + 1
mydata2$TIME2[windowH:500] = mydata2$TIME[windowH:500]
mydata2 = subset(mydata2, select=-c(TIME))
colnames(mydata2)[2] = "TIME"


ggplot(data = mydata2, aes(x=PLACE, y=TIME, color="black")) + 
  geom_line(data = filter(mydata, YEAR!="2021"), aes(x=PLACE, y=TIME, group=YEAR, color="grey"), size=0.5) +  
  geom_line(size=2) +
  geom_line(data = filter(mydata, YEAR=="2021"), aes(x=PLACE, y=TIME, color="red"), size=2) + 
  #scale_y_time(labels = function(l) strftime(l, '%M:%S')) +
  #custom labels on y-axis
  scale_y_time(limits = c(215,235), 
              #breaks = c(10.8,11.0,11.2,11.4,11.6,11.8,12.0,12.2), 
              breaks = seq(215,235,5),
              labels = function(l) strftime(l, '%M:%S')) +
              #labels = c("10.8","11.0","11.2","11.4","11.6","11.8","12.0","12.2")) +
  
  ggtitle("NCAA DI Men's 1,500m") + 
  xlab("Place") + 
  ylab("Time\n(mm:ss)") + 
  coord_cartesian(xlim = c(-0,500), expand=FALSE) + 
  theme_bw() + 
  theme(axis.title.y=element_text(angle=0, vjust=0.5)) + 
  theme(panel.border = element_blank()) +
  theme(plot.title = element_text(hjust=0.5)) +
  theme(axis.title = element_text(size=12)) +
  scale_color_manual(name="",
                     values=c(red="red", black="black", grey="grey"),
                     labels=c("2012-20 Average", "2012-20 Years", "2021")) + 
  theme(legend.text = element_text(size=12)) + 
  theme(plot.title = element_text(size=14))

  #change resolution when exporting

