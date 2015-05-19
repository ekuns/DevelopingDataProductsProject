
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
     representative positions as recorded in the Congressional Quarterly Almanac (CQA).
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
     that never made it to a vote or never made it out of committee.  It is important
     to note that the values tallied here cannot be compared exactly to the votes
     found on the official Congress web site (or from other sources) -- for those
     issues where a formal vote was help -- because the official vote found anywhere
     other than CQA does not account for paired votes.")
)

# Remember that for things that don't change at run-time, we can directly reference
# them here.  This is invoked once when the app starts.
issuesTab <- tabPanel(
  "The Issues",
  p("The issues included in the source data set are listed below, using the names as
    provided in the source data set file", tags$code("house-votes-84.names"),
    ". The measure of partisanship is a simple one I created, which is the absolute
    value of the difference between the percentage of the two parties that were in
    favor of each issue.  Unknown positions are not included in this calculation.  For
    example, if both parties voted 80% 'yea' on an issue, there is no partisanship.
    On the other hand, if one party voted 80% 'yea' and the other party voted 20% 'yea'
    then there is 60% partisanship."),
  p("While the exact meaning of the votes and issues isn't very important for
    understanding the application, I'll provide some references for many of them
    for historical context."),
  tags$table(class="table",
  tags$thead(tags$tr(
    tags$td("Name"),
    tags$td("Partisanship (%)"),
    tags$td("Description")
  )),
  tags$tbody(
    tags$tr(
      tags$td("handicapped-infants"),
      tags$td(round(partisanship["handicapped_infants"]), 1),
      tags$td("This item refers to the",
              a("Baby Doe Law.", href="http://en.wikipedia.org/wiki/Baby_Doe_Law."),
              "The specific vote referred to is a vote on an",
              a("amendment", href="https://www.govtrack.us/congress/votes/98-1984/h511"),
              "to",
              a("H.R. 1904.", href="https://www.govtrack.us/congress/bills/98/hr1904"),
              "The amendment failed, although the bill itself was passed into law as",
              a("Pub.L. 98-457.", href="http://www.gpo.gov/fdsys/pkg/STATUTE-98/pdf/STATUTE-98-Pg1749.pdf"))
      ), tags$tr(
      tags$td("water-project-cost-sharing"),
      tags$td(round(partisanship["waterproject_cost_sharing"]), 1),
      tags$td("I couldn't locate the specific issue for water project cost sharing.
              Of all the votes, this one was the least partisan.  The vote referred to
              was most likely one of the votes or amendments for either",
              a("H.R.3132", href="https://www.congress.gov/bill/98th-congress/house-bill/3132"),
              "or",
              a("H.R.4397.", href="https://www.congress.gov/bill/98th-congress/house-bill/4397"))
    ), tags$tr(
      tags$td("adoption-of-the-budget-resolution"),
      tags$td(round(partisanship["budget_resolution"]), 1),
      tags$td("The Budget Resolution",
              a("H.Con.Res.280,", href="https://www.congress.gov/bill/98th-congress/house-concurrent-resolution/280"),
              "was a", a("concurrent resolution", href="http://en.wikipedia.org/wiki/Concurrent_resolution"),
              "to continue to fund the government in the absense of a passed budget.
              The vote referred to was either the vote to pass the House on 5 April 1984,
              the vote to agree to Senate amendments on 1 Oct 1984.")
    ), tags$tr(
      tags$td("physician-fee-freeze"),
      tags$td(round(partisanship["dr_fee_freeze"]), 1),
      tags$td(a("The Deficit Reduction Act of 1984,", href="https://www.govtrack.us/congress/bills/98/hr4170"),
              "passed in 1984, included a freeze on fees paid to physicians for
               providing services to patients covered by Medicare.  This rate freeze
               was controvercial, and was opposed by many politicians.  I couldn't
               locate a specific vote of 177 to 247 related to the physician fee
               freeze.  This may just have been a recorded position on this component
               of the Deficit Reduction Act of 1984.")
    ), tags$tr(
      tags$td("el-salvador-aid"),
      tags$td(round(partisanship["el_salvador_aid"]), 1),
      tags$td("During the 1980s, El Salvador was in the middle of a",
              a("civil war.", href="http://en.wikipedia.org/wiki/Salvadoran_Civil_War"),
              "The two parties were split on whether or not we should provide aid
               (as well as what sort of aid, humanitarian or military) to the
               government.  The vote in question is most likely a voice vote held for",
              a("H.R. 4656.", href="https://www.govtrack.us/congress/bills/98/hr4656"))
    ), tags$tr(
      tags$td("religious-groups-in-schools"),
      tags$td(round(partisanship["religious_groups_in_schools"]), 1),
      tags$td("...")
    ), tags$tr(
      tags$td("anti-satellite-test-ban"),
      tags$td(round(partisanship["anti_satellite_test_ban"]), 1),
      tags$td("...")
    ), tags$tr(
      tags$td("aid-to-nicaraguan-contras"),
      tags$td(round(partisanship["aid_to_contras"]), 1),
      tags$td("...")
    ), tags$tr(
      tags$td("mx-missile"),
      tags$td(round(partisanship["mx_missile"]), 1),
      tags$td("The",
              a("MX Missile", href="http://en.wikipedia.org/wiki/LGM-118_Peacekeeper"),
              "(now totally decommissioned) was a land-based ICBM.  The President wanted
               more of them.  The vote referred to here is a vote on",
              a("an amendment", href="https://www.govtrack.us/congress/votes/98-1984/h676"),
              "to",
              a("H.R. 5167.", href="https://www.govtrack.us/congress/bills/98/hr5167"),
              "The bill was passed into law as",
              a("Pub.L. 98-525.", href="http://www.gpo.gov/fdsys/pkg/STATUTE-98/pdf/STATUTE-98-Pg2492.pdf"))
    ), tags$tr(
      tags$td("immigration"),
      tags$td(round(partisanship["immigration"]), 1),
      tags$td("...")
    ), tags$tr(
      tags$td("synfuels-corporation-cutback"),
      tags$td(round(partisanship["synfuels_corp_cutback"]), 1),
      tags$td("...")
    ), tags$tr(
      tags$td("education-spending"),
      tags$td(round(partisanship["ed_spending"]), 1),
      tags$td("...")
    ), tags$tr(
      tags$td("superfund-right-to-sue"),
      tags$td(round(partisanship["superfund_can_sue"]), 1),
      tags$td("...")
    ), tags$tr(
      tags$td("crime"),
      tags$td(round(partisanship["crime"]), 1),
      tags$td("...")
    ), tags$tr(
      tags$td("duty-free-exports"),
      tags$td(round(partisanship["duty_free_exports"]), 1),
      tags$td("...")
    ), tags$tr(
      tags$td("export-administration-act-south-africa"),
      tags$td(round(partisanship["export_admin_south_africa"]), 1),
      tags$td("...")
    )
  ))
)

shinyUI(navbarPage("Predicting Party Affiliation",
                   infoTab, issuesTab,
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
                   tabPanel("The Votes",
                            dataTableOutput('voteTable')
                   )
))
