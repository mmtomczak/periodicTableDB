#!/bin/bash
ELEMENT=$1
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

PRINT_DATA(){
  echo "$1" | while read BAR BAR SYMBOL BAR NAME BAR ATOMIC_NUMBER BAR MASS BAR MELTING BAR BOILING BAR BAR BAR BAR BAR TYPE
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."  
  done
}


# if no input
if [[ ! $ELEMENT ]]
then
  # print message and exit
  echo Please provide an element as an argument.
# if input is a symbol
elif [[ $ELEMENT =~ ^[A-Z]{1}[a-z]?$ ]]
then
  # get data
  DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties ON elements.atomic_number=properties.atomic_number INNER JOIN types on types.type_id=properties.type_id WHERE symbol='$ELEMENT'")
  # if data is empty
  if [[ -z $DATA ]]
  then
    # print message
    echo "I could not find that element in the database."
  else
    # if data is not empty 
    PRINT_DATA "$DATA"
  fi
elif [[ $ELEMENT =~ ^[A-Z]{1}[a-z]{2,} ]]
then
  # get data
  DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties ON elements.atomic_number=properties.atomic_number INNER JOIN types on types.type_id=properties.type_id WHERE name='$ELEMENT'")
  # if data is empty
  if [[ -z $DATA ]]
  then
    # print message
    echo "I could not find that element in the database."
  else
    # if data is not empty print data
    PRINT_DATA "$DATA"
  fi
elif [[ $ELEMENT =~ ^[0-9]{1,3}$ ]]
then
  # get data
  DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties ON elements.atomic_number=properties.atomic_number INNER JOIN types on types.type_id=properties.type_id WHERE elements.atomic_number=$ELEMENT")
  # if data is empty
  if [[ -z $DATA ]]
  then
    # print message
    echo "I could not find that element in the database."
  else
    # if data is not empty print data
    PRINT_DATA "$DATA"
  fi
else
  echo "I could not find that element in the database."
fi