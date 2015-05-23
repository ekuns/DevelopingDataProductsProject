
doPrediction("?","y","n","n","y","y","n")
doPrediction("n","n","y","y","n","n","y") # row 1 == Republican
doPrediction("?","y","?","y","n","n","n") # row 3 == Democrat
doPrediction("n","n","y","y","n","n","n") # row 7 == Democrat voting Y on Dr Fee Freeze

# 5 Republicans didn't vote Y on dr_fee_freeze
# votes[politics$party=="republican" & votes$dr_fee_freeze != "y",]
# 22 Democrats didn't vote N on dr_fee_freeze
# votes[politics$party=="democrat" & votes$dr_fee_freeze != "n",]



# Test some edge cases:

# All 5 Republicans who voted against the Dr Fee Freeze
doPrediction("n", "?", "?", "?", "?", "?", "?") # right
doPrediction("n", "n", "n", "y", "n", "n", "?") # wrong
doPrediction("?", "?", "?", "?", "?", "?", "?") # right
doPrediction("y", "n", "n", "n", "y", "y", "n") # wrong
doPrediction("?", "?", "?", "n", "y", "y", "y") # right
