
library(ggplot2)
library(randomForest)
set.seed(31415)
model <- randomForest(as.factor(party) ~ ., data=politics)
oob_accuracy <- paste(as.character(round((1 - model$err.rate[model$ntree]) * 100, 1)), "%")

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

#doPrediction("?","y","n","n","y","y","n")
#doPrediction("n","n","y","y","n","n","y") # row 1 == Republican
#doPrediction("?","y","?","y","n","n","n") # row 3 == Democrat
#doPrediction("n","n","y","y","n","n","n") # row 7 == Democrat voting Y on Dr Fee Freeze

# 5 Republicans didn't vote Y on dr_fee_freeze
# votes[politics$party=="republican" & votes$dr_fee_freeze != "y",]
# 22 Democrats didn't vote N on dr_fee_freeze
# votes[politics$party=="democrat" & votes$dr_fee_freeze != "n",]


getItem <- function(choice) {
  if (choice == shortNames$handicapped_infants) {
    votes$handicapped_infants
  } else if (choice == shortNames$waterproject_cost_sharing) {
    votes$waterproject_cost_sharing
  } else if (choice == shortNames$dr_fee_freeze) {
    votes$dr_fee_freeze
  } else if (choice == shortNames$budget_resolution) {
    votes$budget_resolution
  } else if (choice == shortNames$el_salvador_aid) {
    votes$el_salvador_aid
  } else if (choice == shortNames$religious_groups_in_schools) {
    votes$religious_groups_in_schools
  } else if (choice == shortNames$ed_spending) {
    votes$ed_spending
  } else if (choice == shortNames$aid_to_contras) {
    votes$aid_to_contras
  } else {
    votes$mx_missile
  }
}

getItemName <- function(choice) {
  if (choice == shortNames$handicapped_infants) {
    uiStrings$handicapped_infants
  } else if (choice == shortNames$waterproject_cost_sharing) {
    uiStrings$waterproject_cost_sharing
  } else if (choice == shortNames$dr_fee_freeze) {
    uiStrings$dr_fee_freeze
  } else if (choice == shortNames$budget_resolution) {
    uiStrings$budget_resolution
  } else if (choice == shortNames$el_salvador_aid) {
    uiStrings$el_salvador_aid
  } else if (choice == shortNames$religious_groups_in_schools) {
    uiStrings$religious_groups_in_schools
  } else if (choice == shortNames$ed_spending) {
    uiStrings$ed_spending
  } else if (choice == shortNames$aid_to_contras) {
    uiStrings$aid_to_contras
  } else {
    uiStrings$mx_missile
  }
}

shinyServer(
  function(input, output) {
    output$oob_accuracy <- renderText({oob_accuracy})
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

    output$voteTable <- renderDataTable(politics)
  }
)
