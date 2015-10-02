#install.packages("lpSolveAPI")
library(lpSolveAPI)

## Set this to your working directory
setwd("E:/NFL Stuff/Fantasy/FantasyLineup")


## FUNCTION ARGUMENTS:
##
## train: 'players list' in .csv format when you enter a FanDuel contest. 
## See here for more details: https://github.com/geekman1/fantasylineup
## Can change FPPG to your expected points for that player
##
## n: Number of top lineups to return
##
## cap: Max salary cap (for FanDuel it is usually 60,000)
##
## constraint: 'none' for no constraints on lineup configuration
## 'all_diff' ensures no two players are from the same team AND
## offensive players do not play against the chosen defense
##
## setplayers: Allows you to force lineups to be chosen with these players included
## It should be in the same format as 'train', with your selected players chosen
##
## Function returns the top n lineups under your constraints, with each team's
## expected total points and the total salary used (will be under the cap)


find_teams <- function(train, n, cap, constraint = c("none", "all_diff"), setplayers = NULL){

  ## set constraints to use
  defense <- ifelse(train$Position == "D", 1, 0)
  qb <- ifelse(train$Position == "QB", 1, 0)
  wr <- ifelse(train$Position == "WR", 1, 0)
  te <- ifelse(train$Position == "TE", 1, 0)
  rb <- ifelse(train$Position == "RB", 1, 0)
  k <- ifelse(train$Position == "K", 1, 0)
  
  ## number of decision variables is equal to the number of fantasy players/teams
  lpfantasy <- make.lp(0, nrow(train))
  
  ## Set objective function with the expected number of points
  set.objfn(lpfantasy, train$FPPG)
  
  ## Make sure the decision variables are binary
  set.type(lpfantasy, seq(1, nrow(train), by=1), type = c("binary"))
  
  ## Add some contraints
  ## Only select one defense, exactly 3 wide receivers, etc.
  ## Depends on what fantasy league you are playing in
  add.constraint(lpfantasy, defense, "=", 1)
  add.constraint(lpfantasy, qb, "=", 1)
  add.constraint(lpfantasy, wr, "=", 3)
  add.constraint(lpfantasy, rb, "=", 2)
  add.constraint(lpfantasy, te, "=", 1)
  add.constraint(lpfantasy, k, "=", 1)
  
  ## Add monetary constraint, max salary for the team
  add.constraint(lpfantasy, train$Salary, "<=", cap)

  ## Set objective direction
  lp.control(lpfantasy, sense='max')
  
  constraint <- match.arg(constraint)
  if(constraint == "all_diff"){
    team_names <- levels(factor(train$Team))  
    for(i in 1:length(team_names)){
      ## label opponent of each player (what defense they are playing against)
      train$check <- ifelse(train$Opponent == team_names[i], 1, 0)
      ## label only that defense with a 1
      train$check <- ifelse(train$Position == "D", 0, train$check) 
      train$check <- ifelse((train$Team == team_names[i] & train$Position == "D"), 1, train$check)
      ## add the set of constraints
      add.constraint(lpfantasy, train$check, "<=", 1)
    }
    train$check <- NULL
  }
  
  if(!is.null(setplayers)){
    if((sum(setplayers$Position == "WR") > 3) || (sum(setplayers$Position == "RB") > 2) || (sum(setplayers$Position == "QB") > 1) ||
        (sum(setplayers$Position == "TE") > 1) || (sum(setplayers$Position == "K") > 1) || (sum(setplayers$Position == "D") > 1))
      stop("One of your positions has too many players")
    
    ## Set constraints that each player here must be in lineup
    for(k in 1:nrow(setplayers)){
      add.constraint(lpfantasy, ifelse(setplayers$Id[k] == train$Id, 1, 0), "=", 1)
    }
  }

  team <- data.frame(matrix(0, 1, ncol(train)+3))
  colnames(team) <- c(colnames(train), "TeamSalary", "TotalPoints", "Team_Num")

  j <- 1
  while(j <= n){
    
    ## Solve the model, if this returns 0 an optimal solution is found
    solve(lpfantasy)
    if(solve(lpfantasy) != 0) stop("Optimization failed at some step")
  
    ## Need to figure out how to handle multiple solutions
    ## get.solutioncount(lpfantasy)

    #this returns the proposed solution
    ## get.objective(lpfantasy)

    ## Make sure the constraints are satisfied!
    ## get.constraints(lpfantasy)

    ## This is the team selection
    ## get.variables(lpfantasy)

    ## Get the players on the team
    team_select <- subset(data.frame(train, get.variables(lpfantasy)), get.variables.lpfantasy. == 1)
    team_select$get.variables.lpfantasy. <- NULL
    team_select$TeamSalary <- sum(team_select$Salary)
    team_select$TotalPoints <- sum(team_select$FPPG)
    team_select$Team_Num <- rep(j, nrow(team_select))
    team <- rbind(team, team_select)
  
    add.constraint(lpfantasy, train$FPPG, "<", (get.objective(lpfantasy) - 0.01))
    j <- j + 1
  }
  
  team <- team[-1,]
  team

}


#################################################################
#################################################################

## Remove all injuries and non-desireable players first
## Change the FPPG column to the number of points you expect 
## the player to make this upcoming week. Currently, the excel 
## output is just the average of their points in previous weeks.
## Keep the format as it is output by FanDuel
train <- read.csv("fantasy_duel_points.csv", header = T)

## Returns the top ten teams with no constraints, subject to the max salary cap of 60,000
test1 <- find_teams(train, 10, 60000, constraint = "none", setplayers = NULL)

## Now restrict so that no two players can be on the same team AND
## offensive players do not play against the chosen defense
test2 <- find_teams(train, 10, 60000, constraint = "all_diff", setplayers = NULL)

## Keep Aaron Rodgers and Seattle Seahawks defense
setplayers <- subset(train, (Id == 6894 | Id == 12550))
test3 <- find_teams(train, 10, 60000, constraint = "none", setplayers = setplayers)

