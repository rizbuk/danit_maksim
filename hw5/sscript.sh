#!/bin/bash

WATCH_DIR="$HOME/watch"
mkdir -p "$WATCH_DIR"

while true; do
    # Перебираем все файлы в директории
    for file in "$WATCH_DIR"/*; do
        # Проверяем: существует ли файл и НЕ заканчивается ли он на .back
        if [[ -f "$file" && ! "$file" == *.back ]]; then
            echo "--- Содержимое $(basename "$file") ---"
            cat "$file"
            echo -e "\n----------------------------"
            
            # Переименовываем
            mv "$file" "${file}.back"
        fi
    done
    sleep 2 # Пауза, чтобы не нагружать процессор
done
