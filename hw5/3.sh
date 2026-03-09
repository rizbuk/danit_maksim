#!/bin/bash

echo "filename:"
read FILE

if [ -f "$FILE" ]; then
    echo "file '$FILE' here ."
else
    echo "file '$FILE' nema"
fi
