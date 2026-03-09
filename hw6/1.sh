#!/bin/bash

number=$(( (RANDOM % 100) + 1 ))
attempts=5

for (( i=1; i<=attempts; i++ ))
do
    read -p "Попытка $i/$attempts. Ваш вариант: " guess

    if [[ $guess -eq $number ]]; then
        echo "Congratulations! You guessed the right number."
        exit 0
    elif [[ $guess -lt $number ]]; then
        echo "Too low"
    else
        echo "Too high"
    fi
done

echo "Sorry, you've run out of attempts. The correct number was $number"
