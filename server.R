## @knitr Fit

library(ggplot2)
library(randomForest)
set.seed(31415)
model <- randomForest(as.factor(party) ~ .,
                      data=politics, ntree=100)
oob_accuracy <-
  round((1 - model$err.rate[model$ntree]) * 100, 1)

## @knitr NotUsedInPresentationBelowHere

doPrediction <- function(hi, br, dff, esa, atc, mm, es) {
  # randomForest's predict function absolutely requires that the inputs be factors
  # with the exact same set of levels, so we have to create each item as a factor.
  mylevels <- levels(politics$budget_resolution)
  df <- data.frame(handicapped_infants=factor(hi, mylevels),
                   budget_resolution=factor(br, mylevels),
                   dr_fee_freeze=factor(dff, mylevels),
                   el_salvador_aid=factor(esa, mylevels),
                   aid_to_contras=factor(atc, mylevels),
                   mx_missile=factor(mm, mylevels),
                   ed_spending=factor(es, mylevels))
  as.character(predict(model, newdata=df))
}

getItem <- function(choice) {
  # The +1 is because the Choice column is first
  votes[, grep(choice, shortNames) + 1]
}

getItemName <- function(choice) {
  uiStrings[grep(choice, shortNames)]
}

shinyServer(
  function(input, output) {
    output$oob_accuracy <- renderText({as.character(oob_accuracy)})
    output$prediction <- renderPrint({
      doPrediction(input[[shortNames$handicapped_infants]], input[[shortNames$budget_resolution]],
                   input[[shortNames$dr_fee_freeze]], input[[shortNames$el_salvador_aid]],
                   input[[shortNames$aid_to_contras]], input[[shortNames$mx_missile]],
                   input[[shortNames$ed_spending]])
    })

    output$voteHistogram <- renderPlot({
      item <- getItem(input$HistoChoice)
      newFrame <- data.frame(freq=table(item, politics$party), fac=levels(item))
      ggplot(data=newFrame, aes(x=fac, y=freq.Freq, fill=freq.Var2)) +
        geom_bar(stat="identity") +
        facet_wrap(~ freq.Var2, nrow=2) +
        scale_x_discrete(breaks=c("?", "n", "y"), labels=c("Unspecified", "Against", "For")) +
        xlab("Position on issue") + ylab("Number of votes") +
        guides(fill=guide_legend(title="Party Affiliation"))
    })

    output$voteXYPlot <- renderPlot({
      xItem <- getItem(input$plotX)
      xName <- getItemName(input$plotX)
      yItem <- getItem(input$plotY)
      yName <- getItemName(input$plotY)
      newFrame <- data.frame(x=xItem, y=yItem, party=politics$party)
      ggplot(data=newFrame, aes(x=x, y=y, color=party)) +
        geom_point(position="jitter") +
        scale_x_discrete(breaks=c("?", "n", "y"), labels=c("Unspecified", "Against", "For")) +
        scale_y_discrete(breaks=c("?", "n", "y"), labels=c("Unspecified", "Against", "For")) +
        xlab(paste("Position on", xName)) + ylab(paste("Position on", yName)) +
        guides(color=guide_legend(title="Party Affiliation"))
    })

    output$voteTable <- renderDataTable(if (input$fullDataSet == TRUE) votes else politics)
  }
)
