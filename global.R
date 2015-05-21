# Global.R - for objects shared between server.R and ui.R
# This function is called before server.R and before ui.R
#########################################################

# Define the full set of columns in the data and read in the CSV file
cols <- c("party","handicapped_infants","waterproject_cost_sharing","budget_resolution",
          "dr_fee_freeze","el_salvador_aid","religious_groups_in_schools",
          "anti_satellite_test_ban","aid_to_contras","mx_missile","immigration",
          "synfuels_corp_cutback","ed_spending","superfund_can_sue","crime",
          "duty_free_exports","export_admin_south_africa")
pol <- read.table("data/house-votes-84.data", header=F, sep=",", col.names=cols)

# Now cut the data.frame down to just the important columns
importantCols <- c("party","budget_resolution","dr_fee_freeze","el_salvador_aid",
                   "aid_to_contras","mx_missile","ed_spending")
politics <- pol[,importantCols]

# Simple definition of partisanship...
partisanship <- apply(pol[,-1], 2, function(x)
  (abs(sum(x == "y" & pol$party=="democrat") / sum(x != "?" & pol$party=="democrat") -
       sum(x == "y" & pol$party=="republican") / sum(x != "?" & pol$party=="republican"))) * 100
)
