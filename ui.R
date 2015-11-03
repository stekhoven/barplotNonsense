# D. Stekhoven, 2015, stekhoven@nexus.ethz.ch

library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Why barplots are (often) nonsense"),
  p("Author: Daniel Stekhoven, ", a("stekhoven@nexus.ethz.ch", href="mailto:stekhoven@nexus.ethz.ch"), ",", a("www.nexus.ethz.ch", href="http://www.nexus.ethz.ch"), "   -   Encouraged to be freely used for teaching!"),
  
  # Plots next to each other
  fluidRow(
    column(3,
           h3("Scatter Plot"),
           plotOutput("scatterPlot")
    ),
    column(3,
           h3("Bar Plot"),
           plotOutput("barPlot")
    ),
    column(3,
           h3("Box Plot"),
           plotOutput("boxPlot")
    ),
    column(3,
           h3("Violin Plot"),
           plotOutput("violinPlot")
    )
  ),
  
  hr(),
  
  # Bottom layout for each plot
  fluidRow(
    # scatter plot -----------------------------------------------------------
    column(3,
           p("Above we have a scatter plot showing six groups of observations, each with the same number of observations (select below). At first glance you can see that all six groups are very different from each other. Thus using a scatter plot to show your data is usually not a bad idea (especially if you have less than 100 observations in a single plot), but more importantly it is necessary that you take a look at your data early in your analysis, before you start aggregating your data into summaries of any kind."),
      selectInput("n", "Number of observations per group", c(20, 40, 60, 80)),
      p("Increase the number of observations to see the effect in all plots.")
    ),
    # bar plot ---------------------------------------------------------------
    column(3,
           p("Bar plots are widely used in scientific literature to compare groups of measurements. Often (but not always) error bars are added to the bars with the intention to illustrate the spread of the data or indicate some differences between groups - sometimes as a substiute to a sound statistical test. We can see that this way of visualisation is nonsense. Moreover, the use of standard error bars is at least misleading."),
           selectInput("seBar", "What type of whiskers", c("Standard Error"="se", "Standard Deviation"="sd", "Confidence Interval"="ci")),
           p("Change the type of whiskers to see the misleading visual effect of these error bars.")
    ),
    # box plot ---------------------------------------------------------------
    column(3,
      p("Box plots are a good way to describe the spread of data. The bold line inside the box indicates the median. The upper edge of the box is the 75% quantile (or third quartile) of the data. The lower edge is the 25% quantile (or first quartile) of the data. The whiskers extend as far as 1.5 times the interquartile range (IQR) from the median. The IQR is the distance between the first and third quartile. Observations outside of the whiskers are plotted as points and indicate extreme observations."), 
      p("Note that the above definitions can be changed to cover other quantiles with the box and other ranges with the whiskers, e.g., you could have 5% and 95% quantiles and the whiskers extending to the maximum and minimum observation instead.")
    ),
    # violin plot ------------------------------------------------------------
    column(3,
      p("Similar to the box plot the violin plot illustrates effectively the spread of the data. Instead of using quantiles it shows probability densities of the data. The density curve for each group is mirrored. It is useful to indicate the median in the violins."),
      sliderInput("bwAdjust", "Bandwith of violin", min=0.1, max=1, value=1),
      p("Adjust the bandwidth of the density estimation to get a closer density fit. Note how this has a more pronounced visualisation effect when having more observations per group."),
      radioButtons("trimViolin", "Trim densities to range of data", c("Yes"=TRUE, "No"=FALSE), TRUE, inline=TRUE),
      p("It is useful to trim the density curves to the range of the data to avoid the impression of a much larger spread of the data.")
    )
  )
))
