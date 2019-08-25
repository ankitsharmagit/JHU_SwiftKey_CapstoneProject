#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#



library(shiny)
library(tm)
#install.packages("SnowballC")
library(SnowballC)
library(rJava)
library(RWeka)
library(stringr)
library(data.table)



shinyServer(function(input, output) {
    predWordProb<-function(inputword){
        
        
        inputwords <- trimws(inputword)
        if (length(unlist(strsplit(inputwords," ")))>=3){
            last3Word<-word(inputwords, start = -3L, end = -1L, sep = fixed(" "))
            regex <- sprintf("%s%s%s", "^", last3Word, " ")
            fourgram_indices <- grep(regex, fourgram$Words)
            
            if (length(fourgram_indices)==0) {
                last2Word<-word(inputwords, start = -2L, end = -1L, sep = fixed(" "))
                regex <- sprintf("%s%s%s", "^", last2Word, " ")
                trigram_indices <- grep(regex, trigram$Words)
                
                
                if (length(trigram_indices)==0) {
                    last1Word<-word(inputwords, start = -1L, end = -1L, sep = fixed(" "))
                    regex <- sprintf("%s%s%s", "^", last1Word, " ")
                    bigram_indices <- grep(regex, bigram$Words)
                    
                    unigramcount<-grep(last1Word, unigram$Words)
                    unigramProb=transform(bigram[bigram_indices,],Frequency=0.4*0.4*Frequency/unigramcount)
                    wordProb=(transform(unigramProb, Words=sub(".*\\s+", '', unigramProb$Words)))
                }
                
                else{
                    bigramcount<-grep(last2Word, bigram$Words)
                    bigramProb=transform(trigram[trigram_indices,],Frequency=0.4*Frequency/bigramcount)
                    wordProb=(transform(bigramProb, Words=sub(".*\\s+", '', bigramProb$Words)))
                }
                
            }
            
            else{
                
                trigramcount<-grep(last3Word, trigram$Words)
                trigramProb=transform(fourgram[fourgram_indices,],Frequency=Frequency/trigramcount)
                wordProb=(transform(trigramProb, Words=sub(".*\\s+", '', trigramProb$Words)))
                
            }
            
        }
        
        
        
        
        if (length(unlist(strsplit(inputwords," ")))==2) {
            last2Word<-word(inputwords, start = -2L, end = -1L, sep = fixed(" "))  
            regex <- sprintf("%s%s%s", "^", last2Word, " ")
            trigram_indices <- grep(regex, trigram$Words)
            if(length(trigram_indices)==0){
                last1Word<-word(inputwords, start = -1L, end = -1L, sep = fixed(" "))
                regex <- sprintf("%s%s%s", "^", last1Word, " ")
                bigram_indices <- grep(regex, bigram$Words)
                
                unigramcount<-grep(last1Word, unigram$Words)
                unigramProb=transform(bigram[bigram_indices,],Frequency=0.4*Frequency/unigramcount)
                wordProb=(transform(unigramProb, Words=sub(".*\\s+", '', unigramProb$Words)))
            }
            
            
            else{
                bigramcount<-grep(last2Word, bigram$Words)
                bigramProb=transform(trigram[trigram_indices,],Frequency=Frequency/bigramcount)
                wordProb=(transform(bigramProb, Words=sub(".*\\s+", '', bigramProb$Words)))
            }
        }
        
        if (length(unlist(strsplit(inputwords," ")))==1) {
            last1Word<-word(inputwords, start = -1L, end = -1L, sep = fixed(" "))
            regex <- sprintf("%s%s%s", "^", last1Word, " ")
            bigram_indices <- grep(regex, bigram$Words)
            
            unigramcount<-grep(last1Word, unigram$Words)
            unigramProb=transform(bigram[bigram_indices,],Frequency=Frequency/unigramcount)
            wordProb=(transform(unigramProb, Words=sub(".*\\s+", '', unigramProb$Words)))
            
        }
        
        colnames(wordProb)<-c("Probability","Word")
        return(wordProb)
    }
    
    
    output$predictedWordMain <- renderText(
        
        predWordProb(input$inputtext)$Word[1]
    )
   
    output$bestwordtable<-renderDataTable(
        options = list(searching = FALSE, paging=FALSE, bInfo=FALSE), 
        
        predWordProb(input$inputtext)[1:5,]
    )
    
    
    
    
})
