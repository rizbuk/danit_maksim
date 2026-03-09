#!/bin/bash

echo "print"
read -r PRIN 

# masiv
MASIV=($PRIN)

# MASIV na oborot 
for (( i=${#MASIV[@]}-1; i>=0; i-- )); do
    echo -n "${MASIV[i]} "
done

