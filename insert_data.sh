#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Column names from games.csv: year,round,winner,opponent,winner_goals,opponent_goals

echo $($PSQL "TRUNCATE teams, games");
echo $($PSQL "ALTER SEQUENCE teams_team_id_seq RESTART WITH 1");

# ADDING TO TEAMS
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
if [[ $WINNER != 'winner' ]]
then
  # get the team_id - from WINNER
  team='$WINNER'
  TEAM_ID1=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  # if not found
  if [[ -z $TEAM__ID1 ]]
  then
    # insert team
    INSERT_WINNING_TEAM_RESULT$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $INSERT_WINNING_TEAM_RESULT == "INSERT 0 1" ]]
    then 
      echo Inserted into teams, $WINNER
    fi
    # get new WINNER team_id
    TEAM_ID1=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi

  # get the team_id - from OPPONENT
  team='$OPPONENT'
  TEAM_ID2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  # if not found
  if [[ -z $TEAM__ID2 ]]
  then
    # insert team
    INSERT_OPPONENT_TEAM_RESULT$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ $INSERT_OPPONENT_TEAM_RESULT == "INSERT 0 1" ]]
    then 
      echo Inserted into teams, $OPPONENT
    fi
    # get new OPPONENT team_id
    TEAM_ID2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi

  # Adding to the table: games
  INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID1, $TEAM_ID2, $WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]] 
  then
    echo Inserted into games.
  fi
fi
done

