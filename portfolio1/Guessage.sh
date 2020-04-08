#! /bin/bash

#Student Name: Drishti Panubhai PATEL
#Student ID: 10447208   
#Assignment 2: Portfolio 1

random=$(( (RANDOM % 50) + 20 ))                                     #Generating random number.

while true; do                                                       #Creating loop.                                                                   

read -p "Guessing any age between 20 - 70: " Guess                    #Recieveing for user input between 20 to 70.

if  [[ $Guess =~ ^-?[0-9]+$ ]]; then                                 #Validating using if-else statement. 

    if (( random > Guess )); then                                    #Condition if random number is greater than user input(Guess).
    echo "Guess is lower!! Please try higher number. "               #Generating output.

    elif (( random < Guess )); then                                  #Condition if random number is smaller than user input(Guess).
    echo "Guess is higher!! Please guess lower number. "             #Generating output.

    else
    echo "Guess is correct. Well done!!!!"                           #Generating output if guess is correct.

    break
    fi

elif [ -z "$Guess" ]; then                                           #Validating and generating error if input is empty.
echo "Input cannot be empty. Please enter valid Guess."

else                                                                 #Generating error if input is invalid.
echo "Invalid input. Try again."                                     


fi
done