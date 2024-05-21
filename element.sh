#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"

QUERY_OUTPUT(){
  echo "$ELEMENT" | while IFS=\| read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING BOILING TYPE
        do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        done
}

if [[ $1 ]]
then 
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE elements.name LIKE '$1%' LIMIT 1")
  else
  ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE elements.atomic_number=$1")
  fi
    if [[ -z $ELEMENT ]]
    then
    echo "I could not find that element in the database."
    else
    QUERY_OUTPUT
    fi
else
echo "Please provide an element as an argument."
fi
: 'INPUT=$1
if [[ -z $INPUT ]]
then
  echo "Please provide an element as an argument."
else
  #NOT A NUMBER
  if [[ ! $INPUT =~ ^[0-9]+$ ]]
  then
    LENGTH=$(echo -n "$INPUT" | wc -m)
    if [[ $LENGTH -gt 2 ]]
    then
      # FULL NAME
      INFORMATION=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$INPUT'")
      if [[ -z $INFORMATION ]]
      then
        echo "I could not find that element in the database."
      else
        QUERY_OUTPUT
      fi
    else
    # ATOMIC SYMBOL
    INFORMATION=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol=$INPUT")
      if [[ -z $INFORMATION ]]
      then
        echo "I could not find that element in the database."
      else
        QUERY_OUTPUT
      fi
  # ATOMIC NUMBER
  INFORMATION=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$INPUT")
    if [[ -z $INFORMATION ]]
    then
      echo "I could not find that element in the database."
    else
      QUERY_OUTPUT
    fi
    fi
  fi
fi'
