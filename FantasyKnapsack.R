#install.packages("lpSolveAPI")
library(lpSolveAPI)

## Set this to your working directory
setwd("E:/NFLStuff/Fantasy/FantasyLineup")


## FUNCTION ARGUMENTS:
##
## train: 'players list' in .csv format when you enter a FanDuel contest. 
## See here for more details: https://github.com/geekman1/fantasylineup
## Can change FPPG to your expected points for that player
##
## cap: Max salary cap (for FanDuel it is usually 60,000)
##
## constraint: 'none' for no constraints on lineup configuration
## 'all_diff' ensures no two players are from the same team AND
## offensive players do not play against the chosen defense
## 'no_opp' ensures at most two players from the same team (include defense) 
## AND offensive players do not face the chosen defense AND offensive 
## players don't face eachother (for example, if NE is playing NYG, you can't 
## have Odell Beckham and Tom Brady)
##
## setplayers: Allows you to force lineups to be chosen with these players included
## It should be in the same format as 'train', with your selected players chosen
##
## pointmax: allows you to set a maximum point limit (useful if you want to 
## generate the second best lineup, etc.)
##
## Function returns the top lineup under your constraints, with each team's
## expected total points and the total salary used (will be under the cap)


find_teams <- function(train, cap, constraint = c("none", "all_diff", "no_opp"), 
                       setplayers = NULL, pointmax = NULL){

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
  
  team_names <- levels(factor(train$Team))  
  
  ## DEPRECATED, but can uncomment if you want to impose the restrictions described on the next two lines
  ## Make sure not to select more than one WR, or more than one RB from a single team
  ## Also, make sure not to select a WR/TE, WR/RB, RB/TE combo from same team
  #for(i in 1:length(team_names)){
  #  position_check <- ifelse((train$Team == team_names[i] & 
  #                             (train$Position == "WR" | train$Position == "RB" | train$Position == "TE")), 1, 0)
  #  add.constraint(lpfantasy, position_check, "<=", 1)
  #}
  
  ## Add monetary constraint, max salary for the team
  add.constraint(lpfantasy, train$Salary, "<=", cap)

  ## Set objective direction
  lp.control(lpfantasy, sense='max')
  
  constraint <- match.arg(constraint)
  if(constraint == "all_diff"){
    for(i in 1:length(team_names)){
      ## label opponent of each player (what defense they are playing against)
      check <- ifelse(train$Opponent == team_names[i], 1, 0)
      ## label only that defense with a 1
      check <- ifelse(train$Position == "D", 0, check) 
      check <- ifelse((train$Team == team_names[i] & train$Position == "D"), 1, check)
      ## add the set of constraints
      add.constraint(lpfantasy, check, "<=", 1)
    }
  }
  
  
  if(constraint == "no_opp"){
    team_names <- levels(factor(train$Team))  
    for(i in 1:length(team_names)){
      ## No more than two players from each team (including that team's defense)
      no_two <- ifelse(train$Team == team_names[i], 1, 0)
      add.constraint(lpfantasy, no_two, "<=", 2)
    }
    for(j in 1:nrow(train)){
      no_opposing <- ifelse(train$Opponent == train$Team[j], 1, 0)
      no_opposing[j] <- 1
      ## To deal with defenses (since Team and Opponent are swtiched for defenses)
      no_opposing <- ifelse(train$Position == "D", 0, no_opposing) 
      no_opposing <- ifelse((train$Team == train$Opponent[j] & train$Position == "D"), 1, no_opposing)
      for(k in 1:nrow(train)){
        out <- rep(0, nrow(train))
        out[j] <- 1
        out[k] <- no_opposing[k]
        add.constraint(lpfantasy, out, "<=", 1)
      }
    }
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
  
  if(!is.null(pointmax)) add.constraint(lpfantasy, train$FPPG, "<", pointmax)

  team <- data.frame(matrix(0, 1, ncol(train)+2))
  colnames(team) <- c(colnames(train), "TeamSalary", "TotalPoints")

  ## Solve the model, if this returns 0 an optimal solution is found
  solve(lpfantasy)
  if(solve(lpfantasy) != 0) stop("Optimization failed at some step")
  
  ## Get the players on the team
  team_select <- subset(data.frame(train, get.variables(lpfantasy)), get.variables.lpfantasy. == 1)
  team_select$get.variables.lpfantasy. <- NULL
  team_select$TeamSalary <- sum(team_select$Salary)
  team_select$TotalPoints <- sum(team_select$FPPG)
  team <- rbind(team, team_select)

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
test1 <- find_teams(train, 60000, constraint = "none", setplayers = NULL, pointmax = NULL)

## Some desirable constraints (don't play against yourself!)
test2 <- find_teams(train, 60000, constraint = "no_opp", setplayers = NULL, pointmax = NULL)

## Now restrict so that no two players can be on the same team AND
## offensive players do not play against the chosen defense
test3 <- find_teams(train, 60000, constraint = "all_diff", setplayers = NULL, pointmax = NULL)

## Keep Aaron Rodgers and Seattle Seahawks defense
setplayers <- subset(train, (Id == 6894 | Id == 12550))
test4 <- find_teams(train, 60000, constraint = "none", setplayers = setplayers, pointmax = NULL)



## Small function to generate the top set of teams
## All arguments are the same, except you must enter the number of top teams to return - 'num_top'

top_teams <- function(train, num_top, cap, constraint, setplayers = NULL, pointmax = NULL){
  result <- find_teams(train, cap, constraint = constraint, setplayers = setplayers, pointmax = pointmax)
  j <- 1
  while(j < num_top){
    result <- rbind(result, find_teams(train, cap, constraint = constraint, setplayers = setplayers, 
                                       pointmax = (result$TotalPoints[nrow(result)] - .001)))
    j <- j+1
  }
  result
}

## Generate the top 5 teams with no constraints (this may be a bit slow with other constraints)
test5 <- top_teams(train, 5, 60000, constraint = "none")

