
choiceList <- c('For'='y','Against'='n','Unspecified'='?')
voteChoices=c('Handicapped Infants'='HandicappedInfants',
              'Medicare Reimbursement Freeze'='DrFeeFreeze',
              'Passing the Budget Resolution'='BudgetResolution',
              'Aid to El Salvador'='ElSalvadorAid',
              'Ed Spending'='EdSpending',
              'Aid To Nicaraguan Contras'='AidToContras',
              'Additional MX Missiles'='MxMissile')

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

predictionTab <- tabPanel(
  "Prediction",
  sidebarLayout(
    sidebarPanel(
      selectInput("HandicappedInfants", "Position on Handicapped Infants:", choices=choiceList),
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
    as that found in CQA, so we only know the votes cast.  We don't know about
    pairings or announced votes."),
  tags$table(class="table",
  tags$thead(tags$tr(
    tags$th("Name"),
    tags$th("Partisanship (%)"),
    tags$th("Vote"),
    tags$th("Status"),
    tags$th("Description")
  )),
  tags$tbody(
    tags$tr(
      tags$td("handicapped-infants"),
      tags$td(round(partisanship["handicapped_infants"], 1)),
      tags$td(a("House Vote #511", href="https://www.govtrack.us/congress/votes/98-1984/h511")),
      tags$td("failed"),
      tags$td("This item refers to the",
              a("Baby Doe Law.", href="http://en.wikipedia.org/wiki/Baby_Doe_Law", target="_blank"),
              "The specific vote referred to is a vote on an amendment to",
              a("H.R. 1904.", href="https://www.govtrack.us/congress/bills/98/hr1904"),
              "The amendment failed, although the bill itself was passed into law as",
              a("Pub.L. 98-457.", href="http://www.gpo.gov/fdsys/pkg/STATUTE-98/pdf/STATUTE-98-Pg1749.pdf"))
      ), tags$tr(
      tags$td("water-project-cost-sharing"),
      tags$td(round(partisanship["waterproject_cost_sharing"], 1)),
      tags$td(a("House Vote #540", href="https://www.govtrack.us/congress/votes/98-1984/h540")),
      tags$td("passed"),
      tags$td("Of all the votes surveyed in the original data source, this one was
               the least partisan.  This vote was on an amendment to",
              a("H.R. 1652.", href="https://www.govtrack.us/congress/bills/98/hr1652"),
              "The amendment passed."
              #Pub.L. 98-404
              )
    ), tags$tr(
      tags$td("adoption-of-the-budget-resolution"),
      tags$td(round(partisanship["budget_resolution"], 1)),
      tags$td(a("House Vote #563", href="https://www.govtrack.us/congress/votes/98-1984/h563")),
      tags$td("passed"),
      tags$td("The Budget Resolution",
              a("H.Con.Res.280,", href="https://www.congress.gov/bill/98th-congress/house-concurrent-resolution/280"),
              "was a", a("concurrent resolution", href="http://en.wikipedia.org/wiki/Concurrent_resolution"),
              "to continue to fund the government in the absense of a passed budget.  This vote
               was to pass the resolution, and it passed.")
    ), tags$tr(
      tags$td("physician-fee-freeze"),
      tags$td(round(partisanship["dr_fee_freeze"], 1)),
      tags$td(a("House Vote #572", href="https://www.govtrack.us/congress/votes/98-1984/h572")),
      tags$td("failed"),
      tags$td(a("The Deficit Reduction Act of 1984,", href="https://www.govtrack.us/congress/bills/98/hr4170"),
              "passed in 1984, included a freeze on fees paid to physicians for
               providing services to patients covered by Medicare.  This rate freeze
               was controvercial, and was opposed by many politicians.  For more context, I found a",
              a("New York Times", href="http://www.nytimes.com/1984/06/23/us/medical-groups-object-to-medicare-fee-plan.html"),
              "article discussing this controvercy.",
              "This vote was a failed amendment to",
              a("H.R. 5394,", href="https://www.govtrack.us/congress/bills/98/hr5394"),
              "which itself failed.  The version of legislation that passed was",
              a("H.R. 4170", href="https://www.govtrack.us/congress/bills/98/hr4170"))
    ), tags$tr(
      tags$td("el-salvador-aid"),
      tags$td(round(partisanship["el_salvador_aid"], 1)),
      tags$td(a("House Vote #623", href="https://www.govtrack.us/congress/votes/98-1984/h623")),
      tags$td("passed"),
      tags$td("During the 1980s, El Salvador was in the middle of a",
              a("civil war.", href="http://en.wikipedia.org/wiki/Salvadoran_Civil_War"),
              "The two parties were split on whether or not we should provide aid
               (as well as what sort of aid, humanitarian or military) to the
               government.  This vote amended",
              a("H.R. 5119", href="https://www.govtrack.us/congress/bills/98/hr5119"),
              "to increase authorization for military and economic aid and to make
              military aid contingent on the Salvadoran government making progress
              on human rights.  H.R. 5119 failed.  Some of the same law was later
              passed in",
              a("S. 960", href="https://www.govtrack.us/congress/bills/99/s960"),
              "in the 99th Congress.")
    ), tags$tr(
      tags$td("religious-groups-in-schools"),
      tags$td(round(partisanship["religious_groups_in_schools"], 1)),
      tags$td(a("House Vote #627", href="https://www.govtrack.us/congress/votes/98-1984/h627")),
      tags$td("failed"),
      tags$td("This vote was an attempt to suspend the rules and hold an immediate vote for",
              a("H.R. 5345", href="https://www.govtrack.us/congress/bills/98/hr5345"),
              "also known as the",
              a("Equal Access Act.", href="http://en.wikipedia.org/wiki/Equal_Access_Act"),
              "Because it was an attempt to suspend the rules, a 2/3 vote was required.
               Ultimately, H.R. 5345 failed.  The Equal Access Act was later enacted into law as",
              a("Pub.L. 98-377", href="http://uscode.house.gov/statutes/pl/98/377.pdf"),
              "as part of",
              a("H.R. 1310.", href="https://www.govtrack.us/congress/bills/98/hr1310"))
    ), tags$tr(
      tags$td("anti-satellite-test-ban"),
      tags$td(round(partisanship["anti_satellite_test_ban"], 1)),
      tags$td(a("House Vote #650", href="https://www.govtrack.us/congress/votes/98-1984/h650")),
      tags$td("passed"),
      tags$td("This vote amended the",
              a("Department of Defense Authorization Act", href="https://www.govtrack.us/congress/bills/98/hr5167"),
              "to put strict requirements on the government's use of funds to test an
              anti-satellite weapon against an object in space.")
    ), tags$tr(
      tags$td("aid-to-nicaraguan-contras"),
      tags$td(round(partisanship["aid_to_contras"], 1)),
      tags$td(a("House Vote #660", href="https://www.govtrack.us/congress/votes/98-1984/h660")),
      tags$td("passed"),
      tags$td("The two parties were split about whether or not the United States
               should supply military aid to the Contras during the",
              a("Nicaraguan Revolution.", href="http://en.wikipedia.org/wiki/Nicaraguan_Revolution"),
              "President Reagan wanted to provide aid while the Democrats were not
               in favor of this aid.  This vote amended",
              a("H.J.Res. 492", href="https://www.govtrack.us/congress/bills/98/hjres492"),
              "This resolution contains the",
              a("Boland Amendment,", href="http://en.wikipedia.org/wiki/Boland_Amendment"),
              "denying this aid.  H.J.Res 492 passed and was signed into law.  It
               was violating this law that caused many senior members of the Reagan
               administration to be indicted as a result of the",
              a("Iran-Contra Scandal.", href="http://en.wikipedia.org/wiki/Iran%E2%80%93Contra_affair")
      )
    ), tags$tr(
      tags$td("mx-missile"),
      tags$td(round(partisanship["mx_missile"], 1)),
      tags$td(a("House Vote #676", href="https://www.govtrack.us/congress/votes/98-1984/h676")),
      tags$td("passed"),
      tags$td("The",
              a("MX Missile", href="http://en.wikipedia.org/wiki/LGM-118_Peacekeeper"),
              "(now totally decommissioned) was a land-based ICBM.  The President wanted
               more of them.  The vote referred to here is a vote on an amendment to",
              a("H.R. 5167.", href="https://www.govtrack.us/congress/bills/98/hr5167"),
              "It provided funds for 15 additional MX Missiles contingent on Congress
               specifically authorizing those funds in a separate vote a year later.
               The bill was passed into law as",
              a("Pub.L. 98-525.", href="http://www.gpo.gov/fdsys/pkg/STATUTE-98/pdf/STATUTE-98-Pg2492.pdf"))
    ), tags$tr(
      tags$td("immigration"),
      tags$td(round(partisanship["immigration"], 1)),
      tags$td(a("House Vote #724", href="https://www.govtrack.us/congress/votes/98-1984/h724")),
      tags$td("passed"),
      tags$td("This was a vote to pass the",
              a("Immigration Reform and Control Act of 1983,", href="https://www.govtrack.us/congress/bills/98/hr1510"),
              "which passed the House but never passed the Senate.  This proposed law was one
               in a string of proposed laws over a period of many years, finally culminating
               in the",
              a("Immigration Reform and Control Act of 1986",
                href="http://en.wikipedia.org/wiki/Immigration_Reform_and_Control_Act_of_1986"),
               "which became law.  Note that both the Acts of 1986 and of 1983 were
                sponsored by",
              a("Romano Mazzoli.", href="https://www.govtrack.us/congress/members/romano_mazzoli/407306"))
    ), tags$tr(
      tags$td("synfuels-corporation-cutback"),
      tags$td(round(partisanship["synfuels_corp_cutback"], 1)),
      tags$td(a("House Vote #783", href="https://www.govtrack.us/congress/votes/98-1984/h783")),
      tags$td("failed"),
      tags$td("This was a failed attempt to pass",
              a("H.Res. 551,", href="https://www.govtrack.us/congress/bills/98/hres551"),
              "a Resolution intended to prevent any funding cuts for the U.S. Synthetic
               Fuels Corporation (SFC) from coming to a vote, specifically the cuts contained in",
              a("H.R. 5973.", href="https://www.govtrack.us/congress/bills/98/hr5973"),
              "which cut $5 billion from the budget of the SFC.  Ultimately, the 98th
               Congress cut the SFC budget by $7 billion.  See this",
              a("New York Times editorial", href="http://www.nytimes.com/1984/09/20/opinion/l-letter-on-energy-214740.html"),
              "for one persective on this issue.")
    ), tags$tr(
      tags$td("education-spending"),
      tags$td(round(partisanship["ed_spending"], 1)),
      tags$td(a("House Vote #788", href="https://www.govtrack.us/congress/votes/98-1984/h788")),
      tags$td("failed"),
      tags$td("The vote measured here is a failed amendment (of an amendment of an
               amendment) to",
              a("H.R. 11.", href="https://www.govtrack.us/congress/bills/98/hr11"),
              "This amendment was an attempt to increase educational spending by
               $33.6 million relative to the level in the unamended bill.  H.R. 11
               eventually died.  Similiar legislation was passed into law as",
              a("S. 2496", href="https://www.govtrack.us/congress/bills/98/s2496"),
              "(sponsored by",
              a("Dan Quayle,", href="https://en.wikipedia.org/wiki/Dan_Quayle"),
              "who later became the Vice President).")
    ), tags$tr(
      tags$td("superfund-right-to-sue"),
      tags$td(round(partisanship["superfund_can_sue"], 1)),
      tags$td(a("House Vote #822", href="https://www.govtrack.us/congress/votes/98-1984/h822")),
      tags$td("passed"),
      tags$td("The",
              a("superfund", href="http://en.wikipedia.org/wiki/Superfund"),
              "was a fund set up to clean up sites polluted with hazardous substances.
               Title II of",
              a("H.R. 5640,", href="https://www.govtrack.us/congress/bills/98/hr5640"),
              "the Superfund Expansion and Protection Act of 1984,",
              a("as introduced,", href="http://thomas.loc.gov/cgi-bin/bdquery/z?d098:HR05640:@@@D&summ2=0&"),
              "created the right for individuals to sue polluters for damages.  This
               successful amendment to H.R. 5640 deleted Title II from the proposed law.
               Ultimately, H.R. 5640 failed in the House and did not become law.")
    ), tags$tr(
      tags$td("crime"),
      tags$td(round(partisanship["crime"], 1)),
      tags$td(a("House Vote #868", href="https://www.govtrack.us/congress/votes/98-1984/h868")),
      tags$td("passed"),
      tags$td("This vote successfully sent",
              a("H.J.Res. 648", href="https://www.govtrack.us/congress/bills/98/hjres648"),
              "back to committee to have \"comprehensive crime control language\" inserted.
               The bill was ultimately passed as",
              a("Pub.L. 98-473.", href="http://www.gpo.gov/fdsys/pkg/STATUTE-98/pdf/STATUTE-98-Pg1837.pdf"),
              "Title II of this law is the",
              a("Comprehensive Crime Control Act of 1984.", href="http://en.wikipedia.org/wiki/Comprehensive_Crime_Control_Act_of_1984"))
    ), tags$tr(
      tags$td("duty-free-exports"),
      tags$td(round(partisanship["duty_free_exports"], 1)),
      tags$td(a("House Vote #886", href="https://www.govtrack.us/congress/votes/98-1984/h886")),
      tags$td("failed"),
      tags$td(a("H.R. 6023", href="https://www.govtrack.us/congress/bills/98/hr6023"),
              "attempted to reintroduce a system of trade preferences for deciding
               whether or not to assign duty-free trade status to other countries.
               The bill ultimately failed.  This vote, which also failed, tried to
               amend this bill to remove three countries from eligibility for
               duty-free status."
      )
    ), tags$tr(
      tags$td("export-administration-act-south-africa"),
      tags$td(round(partisanship["export_admin_south_africa"], 1)),
      tags$td(a("House Vote #904", href="https://www.govtrack.us/congress/votes/98-1984/h904")),
      tags$td("passed"),
      tags$td("This was an amendment to",
              a("H.R. 4230,", href="https://www.govtrack.us/congress/bills/98/hr4230"),
              "the Export Administration Act Amendments of 1984.  While the amendment
               succeeded, the law died.  Interestingly, over 100 Representatives
               either voted \"present\" or didn't vote on this amendment!  This amendment
               restored a ban on bank loans by commercial banks to South Africa, as
               opposition to the then official policy of apartheid.  See",
              a("Title III - South Africa, Subtitle II - Loans", href="https://www.govtrack.us/congress/bills/98/hr4230/summary"),
              "in the summary of the bill.")
    )
  ))
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
    representative positions as recorded in the Congressional Quarterly Almanac (CQA)."),
  p("All",
    a("laws, resolutions, and proclamations", href="http://www.gpo.gov/fdsys/pkg/STATUTE-98/content-detail.html"),
    "from the 98th Congress, 2nd Session, can be downloaded from the US Government
    Publishing Office.  For more information about the meaning of these words (bill,
    resolution, proclamation, and so on), see",
    a("Bills and Resolutions: Examples of How Each Kind Is Used", href="http://assets.opencrs.com/rpts/98-706_20101202.pdf"),
    "at the Congressional Research Service."
    )
)

votesTab <- tabPanel(
  "The Votes",
  dataTableOutput('voteTable')
)

shinyUI(navbarPage(
  "Predicting Party Affiliation",
  welcomeTab,
  introTab,
  tabPanel(
    "Exploration",
    p("To explore the training data, choose one of the tabs below:"),
    tags$hr(),
    tabsetPanel(
      Exploration1dTab,
      Exploration2dTab,
      votesTab
    )
  ),
  predictionTab,
  issuesTab,
  referencesTab
))
