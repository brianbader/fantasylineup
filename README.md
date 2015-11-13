# fantasylineup
Code to optimize fantasy lineup with the ability for restrictions (currently for FanDuel and DraftKings). Essentially, this solves a variant of the knapsack problem using linear programming. 

Code follows the FanDuel structure (D, K, WR, WR, WR, RB, RB, TE, QB) or the DraftKings structure (D, QB, WR, WR, WR, RB, RB, TE, FLEX) where FLEX is an additional WR/TE/RB.

This function returns a number of top teams (in terms of expected points), given a set salary cap. The input file currently should be in the form of the .csv file 'fantasy_points.csv'. Replace the column 'Expected Points' with your own expected points. You will also need to include the player/defense's team and their opponent for that week. This information is all contained in the FanDuel export file (see the screenshot on where to download that). For DraftKings, currently you will need to do some editing on their export file to get it into the format here.


Functionality currently includes two possible restrictions:

1) No two players are from the same team AND that the chosen defense is not playing against any of the offensive players.

2) At most two players from the same team (including defense) AND offensive players don't face each other (for example, if NE is playing NYG, you can't have Odell Beckham and Tom Brady).

Players can also be 'forced' into the lineup, meaning you can build an optimal lineup around a given set of players of your choice.


Need to add:

- ~~Support for DraftKings style lineup and custom style lineups~~

- Support for custom style lineups

- Custom restrictions (for example, running back and wide receiver cannot be on same team)



### There is now an R Shiny app available for this: http://geekman1.shinyapps.io/FF_Lineup_Optimizer



Why is this function needed? Brute force to find the best lineup would require searching through 32x32x(32C3)x(32C2)x32x32 = 3.2876 x 10^12 combinations. This is about 3 trillion lineups, assuming only 32 starting players at each position (in reality there are more than 32 starters, so the number of real possible lineups may easily balloon into the quadrillions).


And here is the top team for week 4 of the 2015 season, with an expected 178.2 points, with a $59,800 salary. Details for the top ten teams are in the file 'output_top_teams.csv'.

 
<table class="table table-bordered table-hover table-condensed">
<thead><tr><th title="Field #1">Position</th>
<th title="Field #2">FirstName</th>
<th title="Field #3">LastName</th>
<th title="Field #4">ExpectedPoints</th>
<th title="Field #5">Salary</th>
<th title="Field #6">Team</th>
<th title="Field #7">Opponent</th>
<th title="Field #8">TeamSalary</th>
<th title="Field #9">TotalPoints</th>
</tr></thead>
<tbody><tr><td>WR</td>
<td>Julio</td>
<td>Jones</td>
<td align="right">28.3</td>
<td align="right">9400</td>
<td>ATL</td>
<td>HOU</td>
<td align="right">59800</td>
<td align="right">178.2</td>
</tr>
<tr><td>QB</td>
<td>Andy</td>
<td>Dalton</td>
<td align="right">23.9</td>
<td align="right">7600</td>
<td>CIN</td>
<td>KC</td>
<td align="right">59800</td>
<td align="right">178.2</td>
</tr>
<tr><td>RB</td>
<td>Latavius</td>
<td>Murray</td>
<td align="right">16.4</td>
<td align="right">7500</td>
<td>OAK</td>
<td>CHI</td>
<td align="right">59800</td>
<td align="right">178.2</td>
</tr>
<tr><td>WR</td>
<td>Larry</td>
<td>Fitzgerald</td>
<td align="right">24.9</td>
<td align="right">7400</td>
<td>ARI</td>
<td>STL</td>
<td align="right">59800</td>
<td align="right">178.2</td>
</tr>
<tr><td>RB</td>
<td>Devonta</td>
<td>Freeman</td>
<td align="right">20.0</td>
<td align="right">7200</td>
<td>ATL</td>
<td>HOU</td>
<td align="right">59800</td>
<td align="right">178.2</td>
</tr>
<tr><td>WR</td>
<td>Travis</td>
<td>Benjamin</td>
<td align="right">19.3</td>
<td align="right">6000</td>
<td>CLE</td>
<td>SD</td>
<td align="right">59800</td>
<td align="right">178.2</td>
</tr>
<tr><td>TE</td>
<td>Austin</td>
<td>Seferian-Jenkins</td>
<td align="right">14.7</td>
<td align="right">5200</td>
<td>TB</td>
<td>CAR</td>
<td align="right">59800</td>
<td align="right">178.2</td>
</tr>
<tr><td>K</td>
<td>Josh</td>
<td>Brown</td>
<td align="right">13.0</td>
<td align="right">4800</td>
<td>NYG</td>
<td>BUF</td>
<td align="right">59800</td>
<td align="right">178.2</td>
</tr>
<tr><td>D</td>
<td>Denver</td>
<td>Broncos</td>
<td align="right">17.7</td>
<td align="right">4700</td>
<td>DEN</td>
<td>MIN</td>
<td align="right">59800</td>
<td align="right">178.2</td>
</tr>
</tbody></table>
