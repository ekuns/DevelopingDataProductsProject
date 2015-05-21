
choiceList <- c('For'='y','Against'='n','Unspecified'='?')
voteChoices=c('Medicare Reimbursement Freeze'='DrFeeFreeze',
              'Passing the Budget Resolution'='BudgetResolution',
              'Aid to El Salvador'='ElSalvadorAid',
              'Ed Spending'='EdSpending',
              'Aid To Nicaraguan Contras'='AidToContras',
              'MX Missile'='MxMissile')

#################################################
# FIXME more of the target= and fix http vs https
#################################################

welcomeTab <- tabPanel(
  "Welcome",
  p("One can use the votes or stated positions of politicians to identify party
     affiliation, given training data.  This web application allows you to select
     a set of positions on political issues (from the 1984 United States House of
     Representatives) and predict the party affiliation of an individual with that
     set of positions.  It also allows exploration of the training data.  Background
     information on the issues and on the data set, plus the training data itself,
     is provided."),
  p("The following tabs are available:"),
  tags$ul(
    tags$li("Welcome - This tab."),
    tags$li("Introduction - A quick introduction to the data set to motivate this
            web application."),
    tags$li("Prediction - Choose positions and watch the prediction get updated
            in real time.  The model is automatically created when this web app
            starts, using the R", tags$code("randomForest"), "package.  The
            prediction is made from that model."),
    tags$li("Exploration - A tab that contains two ways of exploring the
            training dataset.  It contains these tabs internally:",
            tags$ul(
              tags$li("1D Exploration - Explore histograms of the votes by party affiliation."),
              tags$li("2D Exploration - Explore scatterplots of the votes by party
                       affiliation, comparing two different votes against each other."),
              tags$li("The Votes - On this tab, you can view the training set.")
            )),
    tags$li("The Issues - A list of the 16 issues with some background information
            on each issue.  The individual roll call vote each tally was taken
            from is identified here."),
    tags$li("References - All references (including to the original source of
            the data) are found on this tab.")
  ))

introTab <- tabPanel(
  "Introduction",
  p("While many votes are not along party lines, some issues break
     down along party lines to varying degrees."),
  p("This data set compiles a set of 16",
    a("roll call votes", href="https://en.wikipedia.org/wiki/Voting_methods_in_deliberative_assemblies#Voice_votes.2C_rising_votes_.28divisions.29.2C_shows_of_hands.2C_and_recorded_votes"),
    "or recorded positions for all 435 members of the",
    a("United States House of Representatives", href="https://en.wikipedia.org/wiki/United_States_House_of_Representatives"),
    "from the second session of the",
    a("98th Congress", href="http://en.wikipedia.org/wiki/98th_United_States_Congress"),
    "The 98th Congress lasted from January 1983 to January 1985. The second session was
     the second year, starting January 1984."),
  p("For each representative, the following positions were identified:"),
  tags$ul(
    tags$li("yea ('y') - voted for, paired for, or announced for the measure"),
    tags$li("nay ('n') - voted against, paired against, or announced against the measure"),
    tags$li("unknown ('?') - voted 'present', voted 'present' to avoid a conflict of
             interest, or did not vote or otherwise make known any position on the measure")),
  p("Note that unknown or '?' does not indicate that the data is", tags$i("missing"),
    ".  Unstead, as indicated above, it means that the position of that representative
     on that issue is unknown."),
  p(a("Pairing", href="http://en.wikipedia.org/wiki/Pair_%28parliamentary_convention%29#United_States"),
    "allows a representative to be absent from a vote without affecting the outcome.
     Pairing is relatively uncommon today.  On the other hand, representatives who
     are absent from a vote and not part of a pair may later announce from the floor
     how they would have voted, had they been present.  Neither type of \"vote\" is
     counted officially, but both are recorded in the CQA."),
  p("The votes tallied for this study are all roll call votes.  It is important to note that the
     values tallied here cannot be compared exactly to the votes found on the
     official Congress web site (or from other sources).  This is because the vote
     tally found anywhere other than CQA does not account for paired or \"announced\" votes.")
)

referencesTab <- tabPanel(
  "References",
  p("The data set used here is the
     \"Congressional Voting Records Data Set\" from the",
    a("UCI Machine Learning Repository", href="http://archive.ics.uci.edu/ml/datasets/Congressional+Voting+Records"),
    "which can be cited as:"),
  p("Lichman, M. (2013). UCI Machine Learning Repository [http://archive.ics.uci.edu/ml].
     Irvine, CA: University of California, School of Information and Computer Science."),
  p("The data set was compiled by Jeff Schlimmer for his PhD dissertation.  He used
     representative positions as recorded in the Congressional Quarterly Almanac (CQA).")
)

predictionTab <- tabPanel(
  "Prediction",
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
)

Exploration1dTab <- tabPanel(
  "1D Exploration",
  sidebarLayout(
    sidebarPanel(
      selectInput("HistoChoice", "Show histogram of position for:", choices=voteChoices)
    ),
    mainPanel(
      plotOutput('voteHistogram')
    )
  )
)

Exploration2dTab <- tabPanel(
  "2D Exploration",
  sidebarLayout(
    sidebarPanel(
      selectInput("plotX", "X Axis choice:", choices=voteChoices),
      selectInput("plotY", "Y Axis Choice:", choices=voteChoices)
    ),
    mainPanel(
      plotOutput('voteXYPlot')
    )
  )
)

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
    understanding the application, I'll provide some references for them
    for historical context.  Thanks to",
    a("a page at govtrack.us", href="https://www.govtrack.us/congress/votes#session=268&chamber[]=2"),
    "I was able to track each item to a specific roll call vote in the House of
    Representatives.  The information on this web page is not as comprehenstive
    as that found in CQA, so we only know the vote cast.  We don't know about
    pairings or "
    ),
  tags$table(class="table",
  tags$thead(tags$tr(
    tags$td("Name"),
    tags$td("Partisanship (%)"),
    tags$td("Description")
  )),
  tags$tbody(
    tags$tr(
      tags$td("handicapped-infants"),
      tags$td(round(partisanship["handicapped_infants"], 1)),
      tags$td("This item refers to the",
              a("Baby Doe Law.", href="http://en.wikipedia.org/wiki/Baby_Doe_Law", target="_blank"),
              "The specific vote referred to is a vote on an",
              a("amendment", href="https://www.govtrack.us/congress/votes/98-1984/h511"),
              "to",
              a("H.R. 1904.", href="https://www.govtrack.us/congress/bills/98/hr1904"),
              "The amendment failed, although the bill itself was passed into law as",
              a("Pub.L. 98-457.", href="http://www.gpo.gov/fdsys/pkg/STATUTE-98/pdf/STATUTE-98-Pg1749.pdf"))
      ), tags$tr(
      tags$td("water-project-cost-sharing"),
      tags$td(round(partisanship["waterproject_cost_sharing"], 1)),
      tags$td("Of all the votes surveyed in the original data source, this one was
               the least partisan.  This vote was on an",
              a("amendment", href="https://www.govtrack.us/congress/votes/98-1984/h540"),
              "to",
              a("H.R. 1652", href="https://www.govtrack.us/congress/bills/98/hr1652")
              #Pub.L. 98-404
              )
    ), tags$tr(
      tags$td("adoption-of-the-budget-resolution"),
      tags$td(round(partisanship["budget_resolution"], 1)),
      tags$td("The Budget Resolution",
              a("H.Con.Res.280,", href="https://www.congress.gov/bill/98th-congress/house-concurrent-resolution/280"),
              "was a", a("concurrent resolution", href="http://en.wikipedia.org/wiki/Concurrent_resolution"),
              "to continue to fund the government in the absense of a passed budget.
              The vote referred to was either the vote to pass the House on 5 April 1984,
              the vote to agree to Senate amendments on 1 Oct 1984.")
    ), tags$tr(
      tags$td("physician-fee-freeze"),
      tags$td(round(partisanship["dr_fee_freeze"], 1)),
      tags$td(a("The Deficit Reduction Act of 1984,", href="https://www.govtrack.us/congress/bills/98/hr4170"),
              "passed in 1984, included a freeze on fees paid to physicians for
               providing services to patients covered by Medicare.  This rate freeze
               was controvercial, and was opposed by many politicians.  For more context, I found a",
              a("New York Times", href="http://www.nytimes.com/1984/06/23/us/medical-groups-object-to-medicare-fee-plan.html"),
              "article discussing this controvercy.",
              "This vote was a failed",
              a("amendment", href="https://www.govtrack.us/congress/votes/98-1984/h572"),
              "to",
              a("H.R. 5394,", href="https://www.govtrack.us/congress/bills/98/hr5394"),
              "which itself failed.  The version of legislation that passed was",
              a("H.R. 4170", href="https://www.govtrack.us/congress/bills/98/hr4170")
              )
    ), tags$tr(
      tags$td("el-salvador-aid"),
      tags$td(round(partisanship["el_salvador_aid"], 1)),
      tags$td("During the 1980s, El Salvador was in the middle of a",
              a("civil war.", href="http://en.wikipedia.org/wiki/Salvadoran_Civil_War"),
              "The two parties were split on whether or not we should provide aid
               (as well as what sort of aid, humanitarian or military) to the
               government.  The vote in question is most likely a voice vote held for",
              a("H.R. 4656.", href="https://www.govtrack.us/congress/bills/98/hr4656"))
    ), tags$tr(
      tags$td("religious-groups-in-schools"),
      tags$td(round(partisanship["religious_groups_in_schools"], 1)),
      tags$td(
        a("Equal Access Act", href="http://en.wikipedia.org/wiki/Equal_Access_Act"),
        a("H.R. 1310", href="https://www.govtrack.us/congress/bills/98/hr1310"),
        a("Pub.L. 98-377", href="http://uscode.house.gov/statutes/pl/98/377.pdf")
        )
    ), tags$tr(
      tags$td("anti-satellite-test-ban"),
      tags$td(round(partisanship["anti_satellite_test_ban"], 1)),
      tags$td("...")
    ), tags$tr(
      tags$td("aid-to-nicaraguan-contras"),
      tags$td(round(partisanship["aid_to_contras"], 1)),
      tags$td("The two parties were split about whether or not the United States
               should supply military aid to the Contras during the",
              a("Nicaraguan Revolution.", href="http://en.wikipedia.org/wiki/Nicaraguan_Revolution"),
              "President Reagan wanted to provide aid while the Democrats were not
               in favor of this aid.  The issue here must be the",
              a("Boland Amendment,", href="http://en.wikipedia.org/wiki/Boland_Amendment"),
              "denying this aid.  The Boland Amendment is included in both",
              a("H.R.2968", href="https://www.congress.gov/bill/98th-congress/house-bill/2968"),
              "and",
              a("H.R.5167.", href="https://www.congress.gov/bill/98th-congress/house-bill/5167"),
              "Both House Resolutions were signed into law.  It was violating this law that
              caused many senior members of the Reagan administration to be indicted as a result of the",
              a("Iran-Contra Scandal.", href="http://en.wikipedia.org/wiki/Iran%E2%80%93Contra_affair")
      )
    ), tags$tr(
      tags$td("mx-missile"),
      tags$td(round(partisanship["mx_missile"], 1)),
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
      tags$td(round(partisanship["immigration"], 1)),
      tags$td("...")
    ), tags$tr(
      tags$td("synfuels-corporation-cutback"),
      tags$td(round(partisanship["synfuels_corp_cutback"], 1)),
      tags$td("...")
    ), tags$tr(
      tags$td("education-spending"),
      tags$td(round(partisanship["ed_spending"], 1)),
      tags$td("The vote measured here is a",
              a("failed amendment", href="https://www.govtrack.us/congress/votes/98-1984/h788"),
              "to",
              a("H.R. 11", href="https://www.govtrack.us/congress/bills/98/hr11")
              )
    ), tags$tr(
      tags$td("superfund-right-to-sue"),
      tags$td(round(partisanship["superfund_can_sue"], 1)),
      tags$td("...")
    ), tags$tr(
      tags$td("crime"),
      tags$td(round(partisanship["crime"], 1)),
      tags$td("...")
    ), tags$tr(
      tags$td("duty-free-exports"),
      tags$td(round(partisanship["duty_free_exports"], 1)),
      tags$td("...")
    ), tags$tr(
      tags$td("export-administration-act-south-africa"),
      tags$td(round(partisanship["export_admin_south_africa"], 1)),
      tags$td("...")
    )
  ))
)

votesTab <- tabPanel(
  "The Votes",
  dataTableOutput('voteTable')
)

shinyUI(navbarPage(
  "Predicting Party Affiliation",
  welcomeTab,
  introTab,
  predictionTab,
  tabPanel(
    "Exploration",
    tabsetPanel(
      Exploration1dTab,
      Exploration2dTab,
      votesTab
    )
  ),
  issuesTab,
  referencesTab
))
