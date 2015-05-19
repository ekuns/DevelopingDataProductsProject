
library(ggplot2)
library(randomForest)
set.seed(31415)
model <- randomForest(as.factor(party) ~ ., data=politics)
oob_accuracy <- paste(as.character(round((1 - model$err.rate[model$ntree]) * 100, 1)), "%")

doPrediction <- function(br, dff, esa, atc, mm, es) {
  # randomForest's predict function absolutely requires that the inputs be factors
  # with the exact same set of levels, so we have to create each item as a factor.
  mylevels <- levels(politics$budget_resolution)
  df <- data.frame(budget_resolution=factor(br, mylevels),
                   dr_fee_freeze=factor(dff, mylevels),
                   el_salvador_aid=factor(esa, mylevels),
                   aid_to_contras=factor(atc, mylevels),
                   mx_missile=factor(mm, mylevels),
                   ed_spending=factor(es, mylevels))
  as.character(predict(model, newdata=df))
}

#doPrediction("y","n","n","y","y","n")
#doPrediction("n","y","y","n","n","y")
#doPrediction("y","?","y","n","n","n")

getItem <- function(choice) {
  if (choice == "DrFeeFreeze") {
    politics$dr_fee_freeze
  } else if (choice == "BudgetResolution") {
    politics$budget_resolution
  } else if (choice == "ElSalvadorAid") {
    politics$el_salvador_aid
  } else if (choice == "EdSpending") {
    politics$ed_spending
  } else if (choice == "AidToContras") {
    politics$aid_to_contras
  } else {
    politics$mx_missile
  }
}

getItemName <- function(choice) {
  if (choice == "DrFeeFreeze") {
    "dr fee freeze"
  } else if (choice == "BudgetResolution") {
    "budget resolution"
  } else if (choice == "ElSalvadorAid") {
    "el salvador aid"
  } else if (choice == "EdSpending") {
    "ed spending"
  } else if (choice == "AidToContras") {
    "aid to contras"
  } else {
    "mx missile"
  }
}

shinyServer(
  function(input, output) {
    output$oob_accuracy <- renderText({oob_accuracy})
    output$prediction <- renderPrint({
      doPrediction(input$BudgetResolution, input$DrFeeFreeze, input$ElSalvadorAid,
                   input$AidToContras, input$MxMissile, input$EdSpending)
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

    output$voteTable <- renderDataTable(politics)
  }
)
