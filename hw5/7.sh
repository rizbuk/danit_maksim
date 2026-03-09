echo "filename:"
read FILE

if [ -f "$FILE" ]; then
    echo "file '$FILE' here" ;(wc -l "$FILE")
else
    echo "file '$FILE' nema" exit 1
fi
