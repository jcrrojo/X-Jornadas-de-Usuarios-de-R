#Text Mining in R 
#Ted Kwartler #Twitter: @tkwartler 
#Chapter 2 Text Mining Basics

#Set Options 
options(stringsAsFactors=F) 
Sys.setlocale('LC_ALL','C') 

library(rJava)
library(stringi) 
library(stringr) 
library(qdap) 

setwd("D:/FJRA/NLP/TED_01/DATOS/TED")




#PRIMEROS PASOS EN TEXT MINING

text.df<-read.csv('oct_delta.csv')
nchar(head(text.df$text)) 

#Longitud media de los tweets registrados
mean(nchar(text.df$text)) 

#Elecci�n de mensajes con un m�nimo n�mero de caracteres
subset.doc<-subset(text.df,nchar(text.df$text)>20)
mean(nchar(subset.doc$text))

#Sustitucisn m�ltiple
fake.text<-'R text mining is good but text mining in python is also' 
patterns<-c('good','also','text mining') 
replacements<-c('great','just as suitable','tm') 
mgsub(patterns,replacements,fake.text)

#Eliminaci�n directa de puntuaciones
gsub('[[:punct:]]','',text.df[1:5,5])

#Aplicaciones mgsub y paste
patterns<-c('Jan','Feb','Mar','Apr','May','Jun','Jul', 
            'Aug','Sep','Oct','Nov','Dec') 
replacements<-seq(1:12) 
text.df$month<-mgsub(patterns,replacements,text.df$month) 
text.df$combined<-paste(text.df$month, text.df$date,text.df$year,
                        sep='-')




#IDENTIFICACI�N Y ANALISIS DEL AGENTE QUE ESCRIBE EL TWEET

#Asociaci�n de fechas a los datos
library(lubridate) 
text.df$combined<-mdy(text.df$combined)

#Identificaci�n de remitentes en tweets (se destaca la forma de llamar al
#signo *)
agents<-strsplit(text.df$text,'[*]')

#Esta funci�n es interesante para lenguajes como el Esperanto, en este caso
#se utiliza s�lo para asegurar la longitud de la identificaci�n del agente
last.chars<-function(text,num)
{  
  last<-substr(text, nchar(text)-num+1,nchar(text))  
  return(last) 
  }

weekdays<-subset(text.df,text.df$combined >= mdy('10-05-2015') & text.df$combined<= mdy('10-09-2015')) 
table(as.factor(last.chars(weekdays$text,2)))




#B�SQUEDA DE EXPRESIONES EN LOS TWEETS

#B�squeda de expresiones
sorry<-grepl('sorry', text.df$text,ignore.case=T) 
sum(sorry)/nrow(text.df) 

sum(grepl('http', text.df$text, ignore.case =  T))/nrow(text.df) 
sum(grepl('[0-9]{3})|[0-9]{4}', text.df$text))/ nrow(text.df)
text.df$text[901]

#Vectores de pattern. Esta funcisn permite constuir matrices documento-tirmino muy rapidamente
stri_count(text.df$text, fixed='http')
stri_count(text.df$text, fixed='DM')
text.df$text[922]




#Ejercicio: En text.df crear un campo weekday que identifique un dma de la semana con un n�mero del
#1 al 7, siendo el 1 el Lunes. Hacer uso de la funcisn grpel
