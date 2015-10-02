# fantasylineup
Code to optimize fantasy lineup with the ability for restrictions (currently for FanDuel). Essentially, this solves a variant of the knapsack problem. 

Code currently follows the FanDuel structure: D, K, WR, WR, WR, RB, RB, TE, QB

This function returns a number of top teams (in terms of expected points), given a set salary cap. The input file currently should be in the form of the FanDuel player's list .csv file (see screenshot on where to download this). Replace the column 'FPPG' with your own expected points. The default given is an average of each player's points for games played earlier in the season.

Functionality currently includes the restriction that no two players are from the same team AND that the chosen defense is not playing against any of the offensive players. Players can also be 'forced' into the lineup, meaning you can build an optimal lineup around a given set of players of your choice.


Need to add:

- Support for DraftKings style lineup and custom style lineups

- Custom restrictions (for example, running back and wide receiver cannot be on same team)

** Please let me know if there is any other functionality you'd like to see! **