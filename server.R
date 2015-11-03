# D. Stekhoven, 2015, stekhoven@nexus.ethz.ch

library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  
  # produce random data frame
  df <- reactive({
    N <- as.numeric(input$n)
  # generate data frame
  df <- data.frame(measure=c(c(rnorm(floor(N/2), mean=140, sd=10), rnorm(floor(N/2), mean=60, sd=10)),
                             rnorm(N, mean=100, sd=30),
                             c(rnorm(floor(0.2*N), mean=200, sd=5), rnorm(floor(0.8*N), mean=80, sd=5)),
                             c(rnorm(floor(0.8*N), mean=130, sd=5), rnorm(floor(0.2*N), mean=10, sd=5)),
                             c(rnorm(floor(0.2*N), mean=200, sd=5), rnorm(floor(0.6*N), mean=100, sd=10), rnorm(floor(0.2*N), mean=20, sd=5)),
                             c(rep(25, floor(N/4)), rep(75, floor(N/4)), rep(125, floor(N/4)), rep(175, floor(N/4)))),
                   group=factor(rep(LETTERS[1:6], each=N)))
  })
  
  # summarize for barplot
  smry.df <- reactive({
    if (input$seBar=="sd")
      bars <- function(x) sd(x)
    if(input$seBar=="se")
      bars <- function(x) sd(x)/sqrt(10)
    if(input$seBar=="ci")
      bars <- function(x) 2*sd(x)/sqrt(10)
    
    data.frame(group=factor(LETTERS[1:6]),
               mean=tapply(df()$measure, df()$group, mean),
               median=tapply(df()$measure, df()$group, median),
               se=tapply(df()$measure, df()$group, bars))
    })
  
  output$scatterPlot <- renderPlot({
    # draw scatterplot
    g <- ggplot(df(), aes(group, measure))
    g + geom_point(position=position_jitter(0.2), size=5, alpha=0.5) + ylim(-10, 225)
  })
  
  output$barPlot <- renderPlot({
    # draw barplot
    gs <- ggplot(smry.df(), aes(group, mean))
    gs + 
      geom_bar(stat = "identity", position="dodge", fill="black", alpha=0.5) +
      geom_errorbar(aes(ymin=mean-se, ymax=mean+se), width=.2, size=1, color="black") + ylim(-10, 225)
  })
  
  output$boxPlot <- renderPlot({
    # draw boxplot
    g <- ggplot(df(), aes(group, measure))
    g + geom_boxplot(fill="black", alpha=0.5) + ylim(-10, 225)
  })
  
  output$violinPlot <- renderPlot({
    # draw violin plot
    g <- ggplot(df(), aes(group, measure))
    g + geom_violin(fill="black", alpha=0.5, trim=input$trimViolin, adjust=input$bwAdjust) + 
      stat_summary(fun.y="median", geom="point") + ylim(-10, 225)
  })
  
})
