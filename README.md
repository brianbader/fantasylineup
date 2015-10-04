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


 
Id	Position	First.Name	Last.Name	FPPG	Played	Salary	Game	Team	Opponent	Injury.Indicator	Injury.Details	TeamSalary	TotalPoints	   
14190	WR	Julio	Jones	28.3	3	9400	HOU@ATL	ATL	HOU	Q	Hamstring	59800	178.2	   
14225	QB	Andy	Dalton	23.9	3	7600	KC@CIN	CIN	KC			59800	178.2	   
34331	RB	Latavius	Murray	16.4	3	7500	OAK@CHI	OAK	CHI			59800	178.2	   
6883	WR	Larry	Fitzgerald	24.9	3	7400	STL@ARI	ARI	STL			59800	178.2	   
24920	RB	Devonta	Freeman	20	3	7200	HOU@ATL	ATL	HOU	Q	Toe	59800	178.2	   
22035	WR	Travis	Benjamin	19.3	3	6000	CLE@SD	CLE	SD	Q	Ribs	59800	178.2	   
16923	TE	Austin	Seferian-Jenkins	14.7	2	5200	CAR@TB	TB	CAR	O	Shoulder	59800	178.2	   
6522	K	Josh	Brown	13	3	4800	NYG@BUF	NYG	BUF			59800	178.2	   
12531	D	Denver	Broncos	17.7	3	4700	MIN@DEN	DEN	MIN			59800	178.2	 
