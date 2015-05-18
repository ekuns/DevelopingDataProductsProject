
choiceList <- c('For'='y','Against'='n','Unspecified'='?')
voteChoices=c('Doctor Fee Freeze'='DrFeeFreeze',
              'Budget Resolution'='BudgetResolution',
              'El Salvador Aid'='ElSalvadorAid',
              'Ed Spending'='EdSpending',
              'Aid To Contras'='AidToContras',
              'Mx Missile'='MxMissile')

# Define the "information tab" separately so we don't get so many line wraps.
infoTab <- tabPanel(
  "Information",
  p("One can use the votes or stated positions of politicians to identify
     party affiliation.  While a great many votes are not along party lines,
     some contentious issues break down along party lines to varying degrees.
     The data set used here is the \"Congressional Voting Records Data Set\" from the",
    a("UCI Machine Learning Repository",
      href="http://archive.ics.uci.edu/ml/datasets/Congressional+Voting+Records"),
    "which can be cited as:"),
  p("Lichman, M. (2013). UCI Machine Learning Repository [http://archive.ics.uci.edu/ml].
     Irvine, CA: University of California, School of Information and Computer Science."),
  p("This data set compiles a set of 16 votes or recorded positions for all 435 members
     of the United States House of Representatives from the second session of the",
    a("98th Congress", href="http://en.wikipedia.org/wiki/98th_United_States_Congress"),
    "The 98th Congress lasted from January 1983 to January 1985. The second session was
     the second year, starting January 1984."),
  p("The data set was compiled by Jeff Schlimmer for his PhD dissertation.  He used
     representative positions as recorded in the Congressional Quarterly Almanac.
     For each representative, the following positions were identified:"),
  tags$ul(
    tags$li("yea ('y') - voted for, paired for, or announced for the measure"),
    tags$li("nay ('n') - voted against, paired against, or announced against the measure"),
    tags$li("unknown ('?') - voted 'present', voted 'present' to avoid a conflict of
             interest, or did not vote or otherwise make known any position on the measure")),
  p("Note that unknown or '?' does not indicate that the data is missing.  Unstead, as
     indicated above, it means that the position of that representative on that issue
     is unknown."),
  p(a("Pairing", href="http://en.wikipedia.org/wiki/Pair_%28parliamentary_convention%29#United_States"),
    "allows a representative to be absent from a vote without affecting the outcome."),
  p("The positions tallied for this study are a mix of votes for House Resolutions,
     votes for amendments to House Resolutions, and stated positions for proposals
     that never made it to a vote or never made it out of committee.")
)

shinyUI(navbarPage("Predicting Party Affiliation",
                   infoTab,
                   tabPanel("Prediction",
                            sidebarLayout(
                              sidebarPanel(
                                selectInput("DrFeeFreeze", "Position on the Dr Fee Freeze:", choices=choiceList),
                                selectInput("BudgetResolution", "Position on the Budget Resolution:", choices=choiceList),
                                selectInput("ElSalvadorAid", "Position on aid to El Salvador:", choices=choiceList),
                                selectInput("EdSpending", "Position on Education Spending:", choices=choiceList),
                                selectInput("AidToContras", "Position on aid for Contras:", choices=choiceList),
                                selectInput("MxMissile", "Position on MX Missile:", choices=choiceList)
                              ),
                              mainPanel(
                                p('The model accuracy is predicted to be ',
                                  textOutput('oob_accuracy', inline=TRUE),
                                  'based on the out-of-bag error in the random forest fit.'),
                                p('Party affiliation prediction:'),
                                h3(textOutput('prediction'))
                              )
                            )
                   ),
                   tabPanel("1D Exploration",
                            sidebarLayout(
                              sidebarPanel(
                                selectInput("HistoChoice", "Show histogram of position for:", choices=voteChoices)
                              ),
                              mainPanel(
                                plotOutput('voteHistogram')
                              )
                            )
                   ),
                   tabPanel("2D Exploration",
                            sidebarLayout(
                              sidebarPanel(
                                selectInput("plotX", "X Axis choice:", choices=voteChoices),
                                selectInput("plotY", "Y Axis Choice:", choices=voteChoices)
                              ),
                              mainPanel(
                                plotOutput('voteXYPlot')
                              )
                            )
                   ),
                   tabPanel("The Issues",
                            p("More to be added here...")
                            ),
                   tabPanel("The Votes",
                            dataTableOutput('voteTable')
                   )
))
