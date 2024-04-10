#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams,games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != year ]]
  then
  #TABLE teams;
  #GET TEAM ID WINNER
  TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  #IF NOT FOUND
  if [[ -z $TEAM_ID_WINNER ]]
    then
    #INSERT TEAM WINNER
    INSERT_TEAM_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $INSERT_TEAM_WINNER == "INSERT 0 1" ]]
      then
      echo "Inserted into teams: $WINNER"
    fi  
  fi
  #GET TEAM NAME OPPONENT
  TEAM_NAME_OPPONENT=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
  #IF NOT FOUND
  if [[ -z $TEAM_NAME_OPPONENT ]]
    then
    #INSERT TEAM OPPONENT
    INSERT_TEAM_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ $INSERT_TEAM_OPPONENT == "INSERT 0 1" ]]
      then
      echo "Inserted into teams: $OPPONENT"
    fi 
  fi
  #TABLE games
  #WINNER ID
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  #OPPONENT ID
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  #INSERT GAME
  INSERT_GAME=$($PSQL "INSERT INTO games(round,year,winner_id,opponent_id,winner_goals,opponent_goals) VALUES('$ROUND',$YEAR,$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
  if [[ $INSERT_GAME == "INSERT 0 1" ]]
    then
    echo "Inserted into games: $ROUND, $YEAR, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS"
  fi
fi
done