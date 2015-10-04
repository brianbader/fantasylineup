# fantasylineup
Code to optimize fantasy lineup with the ability for restrictions (currently for FanDuel). Essentially, this solves a variant of the knapsack problem using linear programming. 

Code currently follows the FanDuel structure: D, K, WR, WR, WR, RB, RB, TE, QB

This function returns a number of top teams (in terms of expected points), given a set salary cap. The input file currently should be in the form of the FanDuel player's list .csv file (see screenshot on where to download this). Replace the column 'FPPG' with your own expected points. The default given is an average of each player's points for games played earlier in the season.

Functionality currently includes the restriction that no two players are from the same team AND that the chosen defense is not playing against any of the offensive players. Players can also be 'forced' into the lineup, meaning you can build an optimal lineup around a given set of players of your choice.


Need to add:

- Support for DraftKings style lineup and custom style lineups

- Custom restrictions (for example, running back and wide receiver cannot be on same team)

** Please let me know if there is any other functionality you'd like to see! **



Why is this function needed? Brute force to find the best lineup would require searching through 32x32x(32C3)x(32C2)x32x32 = 3.2876 x 10^12 combinations. This is about 3 trillion lineups, assuming only 32 starting players at each position (in reality there are more than 32 starters, so the number of real possible lineups may easily balloon into the quadrillions).


And here is the top team for week 4 of the 2015 season, with an expected 178.2 points, with a $59,800 salary. Details for the top ten teams are in the file 'output_top_team.csv'.

 
<table border="1">
<tbody><tr><td>Id</td>
<td>Position</td>
<td>First.Name</td>
<td>Last.Name</td>
<td>FPPG</td>
<td>Played</td>
<td>Salary</td>
<td>Game</td>
<td>Team</td>
<td>Opponent</td>
<td>Injury.Indicator</td>
<td>Injury.Details</td>
<td>TeamSalary</td>
<td>TotalPoints</td>
<td>Team_Num</td>
</tr>
<tr><td>14190</td>
<td>WR</td>
<td>Julio</td>
<td>Jones</td>
<td>28.3</td>
<td>3</td>
<td>9400</td>
<td>HOU@ATL</td>
<td>ATL</td>
<td>HOU</td>
<td>Q</td>
<td>Hamstring</td>
<td>59800</td>
<td>178.2</td>
<td>1</td>
</tr>
<tr><td>14225</td>
<td>QB</td>
<td>Andy</td>
<td>Dalton</td>
<td>23.9</td>
<td>3</td>
<td>7600</td>
<td>KC@CIN</td>
<td>CIN</td>
<td>KC</td>
<td> </td>
<td> </td>
<td>59800</td>
<td>178.2</td>
<td>1</td>
</tr>
<tr><td>34331</td>
<td>RB</td>
<td>Latavius</td>
<td>Murray</td>
<td>16.4</td>
<td>3</td>
<td>7500</td>
<td>OAK@CHI</td>
<td>OAK</td>
<td>CHI</td>
<td> </td>
<td> </td>
<td>59800</td>
<td>178.2</td>
<td>1</td>
</tr>
<tr><td>6883</td>
<td>WR</td>
<td>Larry</td>
<td>Fitzgerald</td>
<td>24.9</td>
<td>3</td>
<td>7400</td>
<td>STL@ARI</td>
<td>ARI</td>
<td>STL</td>
<td> </td>
<td> </td>
<td>59800</td>
<td>178.2</td>
<td>1</td>
</tr>
<tr><td>24920</td>
<td>RB</td>
<td>Devonta</td>
<td>Freeman</td>
<td>20</td>
<td>3</td>
<td>7200</td>
<td>HOU@ATL</td>
<td>ATL</td>
<td>HOU</td>
<td>Q</td>
<td>Toe</td>
<td>59800</td>
<td>178.2</td>
<td>1</td>
</tr>
<tr><td>22035</td>
<td>WR</td>
<td>Travis</td>
<td>Benjamin</td>
<td>19.3</td>
<td>3</td>
<td>6000</td>
<td>CLE@SD</td>
<td>CLE</td>
<td>SD</td>
<td>Q</td>
<td>Ribs</td>
<td>59800</td>
<td>178.2</td>
<td>1</td>
</tr>
<tr><td>16923</td>
<td>TE</td>
<td>Austin</td>
<td>Seferian-Jenkins</td>
<td>14.7</td>
<td>2</td>
<td>5200</td>
<td>CAR@TB</td>
<td>TB</td>
<td>CAR</td>
<td>O</td>
<td>Shoulder</td>
<td>59800</td>
<td>178.2</td>
<td>1</td>
</tr>
<tr><td>6522</td>
<td>K</td>
<td>Josh</td>
<td>Brown</td>
<td>13</td>
<td>3</td>
<td>4800</td>
<td>NYG@BUF</td>
<td>NYG</td>
<td>BUF</td>
<td> </td>
<td> </td>
<td>59800</td>
<td>178.2</td>
<td>1</td>
</tr>
<tr><td>12531</td>
<td>D</td>
<td>Denver</td>
<td>Broncos</td>
<td>17.7</td>
<td>3</td>
<td>4700</td>
<td>MIN@DEN</td>
<td>DEN</td>
<td>MIN</td>
<td> </td>
<td> </td>
<td>59800</td>
<td>178.2</td>
<td>1</td>
</tr>
</tbody></table>

