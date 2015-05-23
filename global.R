# Global.R - for objects shared between server.R and ui.R
# This function is called before server.R and before ui.R
#########################################################

# Define the full set of columns in the data and read in the CSV file
cols <- c("party","handicapped_infants","waterproject_cost_sharing","budget_resolution",
          "dr_fee_freeze","el_salvador_aid","religious_groups_in_schools",
          "anti_satellite_test_ban","aid_to_contras","mx_missile","immigration",
          "synfuels_corp_cutback","ed_spending","superfund_can_sue","crime",
          "duty_free_exports","export_admin_south_africa")
votes <- read.table("data/house-votes-84.data", header=F, sep=",", col.names=cols)

# Now cut the data.frame down to just the important columns
importantCols <- c("party","handicapped_infants","budget_resolution","dr_fee_freeze",
                   "el_salvador_aid","aid_to_contras","mx_missile","ed_spending")
politics <- votes[,importantCols]

# Simple definition of partisanship...
partisanship <- apply(votes[,-1], 2, function(x)
  (abs(sum(x == "y" & votes$party=="democrat") / sum(x != "?" & votes$party=="democrat") -
       sum(x == "y" & votes$party=="republican") / sum(x != "?" & votes$party=="republican"))) * 100
)

uiStrings <- data.frame(
  handicapped_infants="The Baby Doe Law",
  waterproject_cost_sharing="Water Project Cost Sharing",
  budget_resolution="Passing the Budget Resolution",
  dr_fee_freeze="Medicare Reimbursement Freeze",
  el_salvador_aid="Aid to El Salvador",
  religious_groups_in_schools="Religious Student Groups in Schools",
  anti_satellite_test_ban="Anti-Satellite Test Ban",
  aid_to_contras="Aid To Nicaraguan Contras",
  mx_missile="Additional MX Missiles",
  immigration="Comprehensive Immigration Reform",
  synfuels_corp_cutback="Cutting the US SynFuel Corp",
  ed_spending="Increased Education Spending",
  superfund_can_sue="Allowing Direct Suing of Polluters",
  crime="Tough-on-Crime Legislation",
  duty_free_exports="Restricting Duty-Free Export Status",
  export_admin_south_africa="Anti-Apartheid Legislation",
  stringsAsFactors=FALSE)

shortNames <- data.frame(
  handicapped_infants="BabyDoeLaw",
  waterproject_cost_sharing="CostSharing",
  budget_resolution="BudgetResolution",
  dr_fee_freeze="MedicareFreeze",
  el_salvador_aid="ElSalvadorAid",
  religious_groups_in_schools="ReligiousStudentGroups",
  anti_satellite_test_ban="AntiSatelliteTestBan",
  aid_to_contras="AidToContras",
  mx_missile="MoreMXMissiles",
  immigration="ImmigrationReform",
  synfuels_corp_cutback="CuttingSFC",
  ed_spending="MoreEducationSpending",
  superfund_can_sue="SuperfundAllowSuing",
  crime="CrimeLegislation",
  duty_free_exports="DutyFreeExports",
  export_admin_south_africa="AntiApartheid",
  stringsAsFactors=FALSE)
