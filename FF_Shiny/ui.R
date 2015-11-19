
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(DT)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Fantasy Football Optimizer"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      helpText("App to generate the top fantasy teams for FanDuel and DraftKings. Upload files in the format of the 
sample files below to generate top teams based on the expected points given. 'All Players' (required) is the file 
containing all players used to generate the lineups. 'Forced Players' (optional) contains players that you want to force 
into all generated lineups. If you want to exclude players from being used, simply don't include them in either file. 
Adding constraints significantly slows down the team generation, so test with just the single top team first. Constraints 
refer to restrictions #1 and #2 in the github readme, respectively. See the github link below for details.
"),
      a("Github Fantasy Lineup", href = "https://github.com/geekman1/fantasylineup/"),
      tags$div(HTML("<br>")),
      a("All Players Sample File", href = "https://www.dropbox.com/s/dqwtjklhfhy473g/fantasy_points.csv?dl=0"),
      tags$div(HTML("<br>")),
      a("Forced Players Sample File", href = "https://www.dropbox.com/s/2qpt3ydmztyqkn3/player_set.csv?dl=0"),
      tags$hr(),
      numericInput("cap", 
                   "Salary Cap:",
                   min = 0,
                   max = 1000000,
                   value = 60000),
      numericInput("num_top", 
                   "Number of Top Teams:",
                   min = 1,
                   max = 100,
                   value = 1),
      selectInput("constraints", 
                  "Type of Constraint:",
                  c("None" = "none", "All Different" = "all_diff", "No Opponent" = "no_opp")),
      selectInput("league", 
                  "Choose League:",
                  c("FanDuel" = "FanDuel", "DraftKings" = "DraftKings")),
      fileInput("player_all", "Upload CSV File Of All Players:", FALSE, 
                c("csv")),
      fileInput("player_set", "Upload CSV File Of Forced Players (Optional):", FALSE, 
                c("csv")),
      submitButton("Submit")
    ),
    
    
    mainPanel(
      
      dataTableOutput('mytable')
      
    )
    
    
  )
)
)
